CREATE OR REPLACE package body so4_task_pkg is
   /******************************************************************************
   NOME:        so4_task_pkg.
   DESCRIZIONE: Procedure e Funzioni di utilita' per la gestione dei tasks di so4
   ANNOTAZIONI: .
   REVISIONI: .
   Rev.  Data        Autore  Descrizione.
   00    08/07/2015  MM      Prima emissione.                                                          
   ******************************************************************************/
   s_revisione_body constant varchar2(30) := '00';
   s_data_limite date := to_date(3333333, 'j');
   s_oggi        date := trunc(sysdate);
   ----------------------------------------------------------------------------------
   function versione return varchar2 is
      /******************************************************************************
       NOME:        versione.
       DESCRIZIONE: Restituisce versione e revisione di distribuzione del package.
       RITORNA:     VARCHAR2 stringa contenente versione e revisione.
       NOTE:        Primo numero  : versione compatibilita del Package.
                    Secondo numero: revisione del Package specification.
                    Terzo numero  : revisione del Package body.
      ******************************************************************************/
   begin
      return s_revisione || '.' || s_revisione_body;
   end versione;
   ----------------------------------------------------------------------------------
   function get_task_id return task_funzioni.id_task%type is
      /******************************************************************************
           NOME:        get_task_id
           DESCRIZIONE: Restituisce nuova chiave per inserimento record task_funzioni
           Rev.  Data        Autore  Descrizione.
           00    08/07/2015  MM      Prima emissione. 
      ******************************************************************************/
      d_result task_funzioni.id_task%type;
   begin
      select nvl(max(id_task), 0) + 1 into d_result from task_funzioni;
      return d_result;
   end get_task_id;
   ----------------------------------------------------------------------------------
   function get_tipo_parametro(p_id_parametro in parametri_funzione.id_parametro_funzione%type)
      return parametri_funzione.tipo%type is
      /******************************************************************************
           NOME:        get_tipo_parametro
           DESCRIZIONE: Restituisce il tipo del parametro
           Rev.  Data        Autore  Descrizione.
           00    08/07/2015  MM      Prima emissione. 
      ******************************************************************************/
      d_result parametri_funzione.tipo%type;
   begin
      begin
         select tipo
           into d_result
           from parametri_funzione
          where id_parametro_funzione = p_id_parametro;
      exception
         when no_data_found then
            d_result := '';
      end;
      return d_result;
   end get_tipo_parametro;
   ----------------------------------------------------------------------------------
   function is_valore_ok
   (
      p_id_parametro in parametri_funzione.id_parametro_funzione%type
     ,p_valore       in parametri_funzione.valore_default%type
   ) return number is
      /******************************************************************************
        NOME:        is_valore_ok
        DESCRIZIONE: Esegue i controlli di range e dimensione sui valori dei parametri
                     Restituisce
                     1    = ok
                     0    = errato o non determinabile
        Rev.  Data        Autore  Descrizione.
        00    08/07/2015  MM      Prima emissione. 
      ******************************************************************************/
      d_result         number := 1;
      d_dettaglio      varchar2(200);
      d_tipo           parametri_funzione.tipo%type;
      d_dim            parametri_funzione.dimensione%type;
      d_min            parametri_funzione.valore_min%type;
      d_max            parametri_funzione.valore_max%type;
      d_obbligatorio   parametri_funzione.obbligatorio%type;
      d_numero         number := to_number(null);
      d_data           date;
      d_valore         parametri_funzione.valore_default%type := p_valore;
      d_valore_default parametri_funzione.valore_default%type;
   begin
      begin
         select tipo
               ,dimensione
               ,valore_min
               ,valore_max
               ,obbligatorio
               ,valore_default
           into d_tipo
               ,d_dim
               ,d_min
               ,d_max
               ,d_obbligatorio
               ,d_valore_default
           from parametri_funzione p
          where id_parametro_funzione = p_id_parametro;
      
         if d_obbligatorio = 'SI' and d_valore is null and d_valore_default is null then
            d_result := 0;
         elsif d_valore is null then
            d_valore := d_valore_default;
         end if;
      
         if d_tipo = 'C' and d_result = 1 then
            if not (length(d_valore) <= d_dim or d_dim is null) then
               d_result := 0;
            end if;
         elsif d_tipo = 'N' and d_result = 1 then
            if instr(d_valore, '.') > 0 then
               begin
                  d_numero := to_number(d_valore);
               exception
                  when others then
                     begin
                        d_numero := to_number(replace(d_valore, '.', ','));
                     exception
                        when others then
                           null;
                     end;
               end;
            elsif instr(d_valore, ',') > 0 then
               begin
                  d_numero := to_number(d_valore);
               exception
                  when others then
                     begin
                        d_numero := to_number(replace(d_valore, ',', '.'));
                     exception
                        when others then
                           null;
                     end;
               end;
            else
               begin
                  d_numero := to_number(d_valore);
               exception
                  when others then
                     null;
               end;
            end if;
            if d_numero is not null and (d_numero >= to_number(d_min) or d_min is null) and
               (d_numero <= to_number(d_max) or d_max is null) then
               d_result := 1;
            else
               d_result := 0;
            end if;
         elsif d_tipo = 'D' and d_result = 1 then
            begin
               d_data   := to_date(d_valore, 'dd/mm/yyyy');
               d_result := 1;
            exception
               when others then
                  d_result := 0;
            end;
         end if;
      exception
         when no_data_found then
            d_result := 0;
      end;
   
      return d_result;
   end is_valore_ok;
   ----------------------------------------------------------------------------------
   procedure esegui_task(p_id_task in task_funzioni.id_task%type) is
      /******************************************************************************
       NOME:        esegui_task.
       DESCRIZIONE: predispone ed esegue lo statement del task
       REVISIONI:
       Rev. Data         Autore      Descrizione
       ---- -----------  ----------  ------------------------------------------------
       000   08/07/2015  MM          Prima emissione.
      ******************************************************************************/
   
      d_wrk_task  task_funzioni%rowtype;
      d_result    number;
      d_statement varchar2(2000);
   begin
      select 'begin ' || funzione || ' ('
        into d_statement
        from funzioni
       where id_funzione =
             (select id_funzione from task_funzioni where id_task = p_id_task);
   
      for para in (select p.id_parametro_funzione
                         ,p.sequenza
                         ,p.label
                         ,nvl(decode(p.sequenza
                                    ,1
                                    ,t.valore_parametro_1
                                    ,2
                                    ,valore_parametro_2
                                    ,3
                                    ,valore_parametro_3
                                    ,4
                                    ,valore_parametro_4
                                    ,5
                                    ,valore_parametro_5
                                    ,6
                                    ,valore_parametro_6
                                    ,7
                                    ,valore_parametro_7
                                    ,8
                                    ,valore_parametro_8
                                    ,9
                                    ,valore_parametro_9
                                    ,10
                                    ,valore_parametro_10
                                    ,11
                                    ,valore_parametro_11
                                    ,12
                                    ,valore_parametro_12
                                    ,13
                                    ,valore_parametro_13
                                    ,14
                                    ,valore_parametro_14
                                    ,15
                                    ,valore_parametro_15
                                    ,'')
                             ,p.valore_default) valore_parametro
                         ,p.tipo
                     from task_funzioni      t
                         ,parametri_funzione p
                    where t.id_funzione = p.id_funzione
                      and t.id_task = p_id_task
                    order by p.sequenza)
      loop
         if is_valore_ok(para.id_parametro_funzione, para.valore_parametro) = 0 then
            raise_application_error(-20999, 'Parametro '||para.sequenza||' : ' || para.label || ' errato');
         end if;
         if para.valore_parametro is not null then
            if para.tipo = 'C' then
               d_statement := d_statement || '''' || para.valore_parametro || ''',';
            elsif para.tipo = 'D' then
               d_statement := d_statement || 'to_date(''' || para.valore_parametro ||
                              ''',''dd/mm/yyyy''),';
            elsif para.tipo = 'N' then
               d_statement := d_statement || para.valore_parametro || ',';
            end if;
         else
            d_statement := d_statement || '''''' || ',';
         end if;
      end loop;
   
      d_statement := d_statement || p_id_task || '); end;';
   
      begin
         dbms_output.put_line(d_statement);
         execute immediate d_statement;
      
         update task_funzioni set data_termine = systimestamp;
      exception
         when others then
            raise;
      end;
   
   end esegui_task;

-------------------------------------------------------------------------------

end so4_task_pkg;
/

