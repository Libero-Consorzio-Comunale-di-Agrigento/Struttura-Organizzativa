CREATE OR REPLACE package suddivisione_fisica is
   /* MASTER_LINK */
   /******************************************************************************
    NOME:        suddivisione_fisica
    DESCRIZIONE: Gestione tabella suddivisioni_fisiche.
    ANNOTAZIONI: .
    REVISIONI:   Template Revision: 1.12.
    <CODE>
    Rev.  Data       Autore  Descrizione.
    00    05/11/2007  VDAVALLI  Prima emissione.
    01    04/09/2009  VDAVALLI  Modifiche per configurazione master/slave
    02    14/08/2012  mmonari   Revisione complessiva struttura fisica
    03    26/11/2012  mmonari   Redmine #134
    </CODE>
   ******************************************************************************/
   -- Revisione del Package
   s_revisione  constant afc.t_revision := 'V1.03';
   s_table_name constant afc.t_object_name := 'suddivisioni_fisiche';
   subtype t_rowtype is suddivisioni_fisiche%rowtype;
   -- Tipo del record primary key
   type t_pk is record(
       id_suddivisione suddivisioni_fisiche.id_suddivisione%type);
   -- Versione e revisione
   function versione /* SLAVE_COPY */
    return varchar2;
   pragma restrict_references(versione, wnds);
   -- Costruttore di record chiave
   function pk /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return t_pk;
   pragma restrict_references(pk, wnds);
   -- Controllo integrità chiave
   function can_handle /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return number;
   pragma restrict_references(can_handle, wnds);
   -- Controllo integrità chiave
   -- wrapper boolean
   function canhandle /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return boolean;
   pragma restrict_references(canhandle, wnds);
   -- Esistenza riga con chiave indicata
   function exists_id /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return number;
   pragma restrict_references(exists_id, wnds);
   -- Esistenza riga con chiave indicata
   -- wrapper boolean
   function existsid /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type) return boolean;
   pragma restrict_references(existsid, wnds);
   -- Inserimento di una riga
   procedure ins
   (
      p_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type default null
     ,p_amministrazione      in suddivisioni_fisiche.amministrazione%type
     ,p_suddivisione         in suddivisioni_fisiche.suddivisione%type
     ,p_denominazione        in suddivisioni_fisiche.denominazione%type
     ,p_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
   );
   -- Aggiornamento di una riga
   procedure upd
   (
      p_new_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type
     ,p_old_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type default null
     ,p_new_amministrazione      in suddivisioni_fisiche.amministrazione%type default afc.default_null('SUDDIVISIONI_FISICHE.amministrazione')
     ,p_old_amministrazione      in suddivisioni_fisiche.amministrazione%type default null
     ,p_new_suddivisione         in suddivisioni_fisiche.suddivisione%type default afc.default_null('SUDDIVISIONI_FISICHE.suddivisione')
     ,p_old_suddivisione         in suddivisioni_fisiche.suddivisione%type default null
     ,p_new_denominazione        in suddivisioni_fisiche.denominazione%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione')
     ,p_old_denominazione        in suddivisioni_fisiche.denominazione%type default null
     ,p_new_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione_al1')
     ,p_old_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_new_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default afc.default_null('SUDDIVISIONI_FISICHE.denominazione_al2')
     ,p_old_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_new_des_abb              in suddivisioni_fisiche.des_abb%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb')
     ,p_old_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_new_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb_al1')
     ,p_old_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_new_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default afc.default_null('SUDDIVISIONI_FISICHE.des_abb_al2')
     ,p_old_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_new_icona_standard       in suddivisioni_fisiche.icona_standard%type default afc.default_null('SUDDIVISIONI_FISICHE.icona_standard')
     ,p_old_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_new_nota                 in suddivisioni_fisiche.nota%type default afc.default_null('SUDDIVISIONI_FISICHE.nota')
     ,p_old_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_new_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default afc.default_null('SUDDIVISIONI_FISICHE.utente_aggiornamento')
     ,p_old_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_new_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default afc.default_null('SUDDIVISIONI_FISICHE.data_aggiornamento')
     ,p_old_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_new_assegnabile          in suddivisioni_fisiche.assegnabile%type default afc.default_null('SUDDIVISIONI_FISICHE.assegnabile')
     ,p_old_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_new_ordinamento          in suddivisioni_fisiche.ordinamento%type default afc.default_null('SUDDIVISIONI_FISICHE.ordinamento')
     ,p_old_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
     ,p_check_old                in integer default 0
   );
   -- Aggiornamento del campo di una riga
   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in varchar2 default null
     ,p_literal_value   in number default 1
   );
   procedure upd_column
   (
      p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type
     ,p_column          in varchar2
     ,p_value           in date
   );
   -- Cancellazione di una riga
   procedure del
   (
      p_id_suddivisione      in suddivisioni_fisiche.id_suddivisione%type
     ,p_amministrazione      in suddivisioni_fisiche.amministrazione%type default null
     ,p_suddivisione         in suddivisioni_fisiche.suddivisione%type default null
     ,p_denominazione        in suddivisioni_fisiche.denominazione%type default null
     ,p_denominazione_al1    in suddivisioni_fisiche.denominazione_al1%type default null
     ,p_denominazione_al2    in suddivisioni_fisiche.denominazione_al2%type default null
     ,p_des_abb              in suddivisioni_fisiche.des_abb%type default null
     ,p_des_abb_al1          in suddivisioni_fisiche.des_abb_al1%type default null
     ,p_des_abb_al2          in suddivisioni_fisiche.des_abb_al2%type default null
     ,p_icona_standard       in suddivisioni_fisiche.icona_standard%type default null
     ,p_nota                 in suddivisioni_fisiche.nota%type default null
     ,p_utente_aggiornamento in suddivisioni_fisiche.utente_aggiornamento%type default null
     ,p_data_aggiornamento   in suddivisioni_fisiche.data_aggiornamento%type default null
     ,p_assegnabile          in suddivisioni_fisiche.assegnabile%type default null
     ,p_ordinamento          in suddivisioni_fisiche.ordinamento%type default null
     ,p_check_old            in integer default 0
   );
   function get_id_suddivisione return suddivisioni_fisiche.id_suddivisione%type;
   -- Attributo amministrazione di riga esistente identificata da chiave
   function get_amministrazione /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.amministrazione%type;
   pragma restrict_references(get_amministrazione, wnds);
   -- Attributo suddivisione di riga esistente identificata da chiave
   function get_suddivisione /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.suddivisione%type;
   pragma restrict_references(get_suddivisione, wnds);
   -- Attributo denominazione di riga esistente identificata da chiave
   function get_denominazione /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione%type;
   pragma restrict_references(get_denominazione, wnds);
   -- Attributo denominazione_al1 di riga esistente identificata da chiave
   function get_denominazione_al1 /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione_al1%type;
   pragma restrict_references(get_denominazione_al1, wnds);
   -- Attributo denominazione_al2 di riga esistente identificata da chiave
   function get_denominazione_al2 /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.denominazione_al2%type;
   pragma restrict_references(get_denominazione_al2, wnds);
   -- Attributo des_abb di riga esistente identificata da chiave
   function get_des_abb /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb%type;
   pragma restrict_references(get_des_abb, wnds);
   -- Attributo des_abb_al1 di riga esistente identificata da chiave
   function get_des_abb_al1 /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb_al1%type;
   pragma restrict_references(get_des_abb_al1, wnds);
   -- Attributo des_abb_al2 di riga esistente identificata da chiave
   function get_des_abb_al2 /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.des_abb_al2%type;
   pragma restrict_references(get_des_abb_al2, wnds);
   -- Attributo icona_standard di riga esistente identificata da chiave
   function get_icona_standard /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.icona_standard%type;
   pragma restrict_references(get_icona_standard, wnds);
   -- Attributo nota di riga esistente identificata da chiave
   function get_nota /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.nota%type;
   pragma restrict_references(get_nota, wnds);
   -- Attributo utente_aggiornamento di riga esistente identificata da chiave
   function get_utente_aggiornamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.utente_aggiornamento%type;
   pragma restrict_references(get_utente_aggiornamento, wnds);
   -- Attributo data_aggiornamento di riga esistente identificata da chiave
   function get_data_aggiornamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.data_aggiornamento%type;
   pragma restrict_references(get_data_aggiornamento, wnds);
   -- Getter per attributo assegnabile di riga identificata da chiave
   function get_assegnabile /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.assegnabile%type;
   pragma restrict_references(get_assegnabile, wnds);
   -- Getter per attributo ordinamento di riga identificata da chiave
   function get_ordinamento /* SLAVE_COPY */
   (p_id_suddivisione in suddivisioni_fisiche.id_suddivisione%type)
      return suddivisioni_fisiche.ordinamento%type;
   pragma restrict_references(get_ordinamento, wnds);
   -- Righe corrispondenti alla selezione indicata
   function get_rows /* SLAVE_COPY */
   (
      p_id_suddivisione      in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_suddivisione         in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_icona_standard       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_ordinamento          in varchar2 default null
     ,p_other_condition      in varchar2 default null
     ,p_qbe                  in number default 0
   ) return afc.t_ref_cursor;
   -- Numero di righe corrispondente alla selezione indicata
   -- Almeno un attributo deve essere valido (non null)
   function count_rows /* SLAVE_COPY */
   (
      p_id_suddivisione      in varchar2 default null
     ,p_amministrazione      in varchar2 default null
     ,p_suddivisione         in varchar2 default null
     ,p_denominazione        in varchar2 default null
     ,p_denominazione_al1    in varchar2 default null
     ,p_denominazione_al2    in varchar2 default null
     ,p_des_abb              in varchar2 default null
     ,p_des_abb_al1          in varchar2 default null
     ,p_des_abb_al2          in varchar2 default null
     ,p_icona_standard       in varchar2 default null
     ,p_nota                 in varchar2 default null
     ,p_utente_aggiornamento in varchar2 default null
     ,p_data_aggiornamento   in varchar2 default null
     ,p_assegnabile          in varchar2 default null
     ,p_ordinamento          in varchar2 default null
     ,p_other_condition      in varchar2 default null
     ,p_qbe                  in number default 0
   ) return integer;
end suddivisione_fisica;
/

