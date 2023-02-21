CREATE OR REPLACE package body external_functions_pkg is
/******************************************************************************
 NOME:        external_functions_pkg
 DESCRIZIONE: Gestione tabella EXTERNAL_FUNCTIONS.
 ANNOTAZIONI: .
 REVISIONI:   .
 Rev.  Data        Autore  Descrizione.
 000   31/05/2007  MMalferrari  Prima emissione.
 001   18/07/2007  MMalferrari  Modifica a crea_trigger_si4ef in modo che, in
                                caso di errore in esecuzione della funzione
                                esterna, blocchi.
                                Modificato il suffisso dei trigger creati da
                                '_SI4EF_TAIUD' IN 'EF_TAIUD'.
 002   08/06/2017  MMalferrari  Modificato ordinamento in crea_trigger_si4ef 
                                - order by COLUMN_NAME desc - per evitare problemi
                                in caso il nome di una colonna contenga il nome
                                di un'altra (ad es. DAL e DAL_PUBB)
******************************************************************************/
   s_revisione_body      constant AFC.t_revision := '001';
--------------------------------------------------------------------------------
function versione
return varchar2 is
/******************************************************************************
 NOME:        versione
 DESCRIZIONE: Versione e revisione di distribuzione del package.
 RITORNA:     varchar2 stringa contenente versione e revisione.
 NOTE:        Primo numero  : versione compatibilità del Package.
              Secondo numero: revisione del Package specification.
              Terzo numero  : revisione del Package body.
******************************************************************************/
begin
   return AFC.version ( s_revisione, s_revisione_body );
end versione; -- external_functions_tpk.versione
PROCEDURE get_function_attributes
( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
, p_function_name out varchar2
, p_package_name out varchar2
, p_parameters out varchar2
, p_db_link out varchar2
) is
/******************************************************************************
 NOME:        get_function_attributes
 DESCRIZIONE: .
 PARAMETRI:   p_firing_function .
 NOTE:        --
******************************************************************************/
   d_pos        integer := 0;
   d_posPar     integer := 0;
   d_posPar2    integer := 0;
   d_function_name varchar2(4000);
begin
   d_function_name := p_firing_function;
   d_posPar := instr(d_function_name, '(');
   if d_posPar > 0 then
      d_posPar2 := instr(d_function_name, ')');
      p_parameters := trim(substr(d_function_name, d_posPar + 1, d_posPar2 - d_posPar - 1));
   else
      p_parameters := '';
      d_posPar := length(d_function_name) + 1;
   end if;
   d_function_name := trim(substr(d_function_name, 1, d_posPar - 1));
   d_pos := instr(d_function_name, '.');
   if d_pos > 0 then
      p_package_name := substr(d_function_name, 1, d_pos - 1);
      d_function_name := substr(d_function_name, d_pos + 1);
   else
      p_package_name := '';
   end if;
   d_pos := instr(d_function_name, '@');
   if d_pos > 0 then
      p_function_name := substr(d_function_name, 1, d_pos - 1);
      p_db_link := substr(d_function_name, d_pos);
   else
      p_function_name := d_function_name;
      p_db_link := '';
   end if;
end get_function_attributes;
FUNCTION get_function_name
( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return varchar2 is
/******************************************************************************
 NOME:        get_function_attributes
 DESCRIZIONE: .
 PARAMETRI:   p_firing_function .
 NOTE:        --
******************************************************************************/
   d_function_name varchar2(30);
   d_package_name  varchar2(30);
   d_parameters    varchar2(4000);
   d_db_link       varchar2(2000);
begin
   get_function_attributes(p_firing_function, d_function_name, d_package_name, d_parameters, d_db_link);
   return d_function_name;
end get_function_name;
FUNCTION get_package_name
( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return varchar2 is
/******************************************************************************
 NOME:        get_function_attributes
 DESCRIZIONE: .
 PARAMETRI:   p_firing_function .
 NOTE:        --
******************************************************************************/
   d_function_name varchar2(30);
   d_package_name  varchar2(30);
   d_parameters    varchar2(4000);
   d_db_link       varchar2(2000);
begin
   get_function_attributes(p_firing_function, d_function_name, d_package_name, d_parameters, d_db_link);
   return d_package_name;
end get_package_name;
FUNCTION get_function_parameters
( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return varchar2 is
/******************************************************************************
 NOME:        get_function_attributes
 DESCRIZIONE: .
 PARAMETRI:   p_firing_function .
 NOTE:        --
******************************************************************************/
   d_function_name varchar2(30);
   d_package_name  varchar2(30);
   d_parameters    varchar2(4000);
   d_db_link       varchar2(2000);
begin
   get_function_attributes(p_firing_function, d_function_name, d_package_name, d_parameters, d_db_link);
   return d_parameters;
end get_function_parameters;
FUNCTION get_db_link
( p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return varchar2 is
/******************************************************************************
 NOME:        get_function_attributes
 DESCRIZIONE: .
 PARAMETRI:   p_firing_function .
 NOTE:        --
******************************************************************************/
   d_function_name varchar2(30);
   d_package_name  varchar2(30);
   d_parameters    varchar2(4000);
   d_db_link       varchar2(2000);
begin
   get_function_attributes(p_firing_function, d_function_name, d_package_name, d_parameters, d_db_link);
   return d_db_link;
end get_db_link;
FUNCTION get_return_type
( p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
, p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return varchar2 is
/******************************************************************************
 NOME:        get_return_type
 DESCRIZIONE: Ritorna il tipo del valore di ritorno di 'p_firing_function'
              dello user 'p_function_owner'.
 PARAMETRI:   p_function_owner   user oracle proprietario
              p_firing_function  funzione da lanciare
 RITORNA:     varchar2: tipo.
 NOTE:        --
******************************************************************************/
   d_parameters varchar2(4000);
   d_package    varchar2(30);
   d_function   varchar2(4000);
   d_return     varchar2(30);
   d_db_link    varchar2(2000);
   d_statement  varchar2(32767);
begin
   get_function_attributes ( p_firing_function
                           , d_function
                           , d_package
                           , d_parameters
                           , d_db_link);
   begin
      d_statement :=
        'select data_type
           FROM ALL_ARGUMENTS'||d_db_link||'
          WHERE OWNER = '''||p_function_owner||'''
            AND OBJECT_NAME = '''||d_function||'''
            AND nvl(PACKAGE_NAME, ''xxx'') = decode('''||d_package||''', to_char(null), ''xxx'', '''||d_package||''')
            and argument_name is null'
      ;
      execute immediate d_statement INTO d_return;
   exception
      when no_data_found then
         d_return := '';
   end;
   return d_return;
end get_return_type;
function is_valid_function
( p_function_owner  in EXTERNAL_FUNCTIONS.function_owner%type
, p_firing_function in EXTERNAL_FUNCTIONS.firing_function%type
) return number is
/******************************************************************************
 NOME:        is_valid_function
 DESCRIZIONE: Controlla:
              1.  che esistano le grant da 'p_function_owner' per l'oggetto
                  'p_firing_function';
              2. che l'oggetto 'p_firing_function' sia valido;
              3. se è un package, che contenga la funzione specificata;
              4. che il numero di parametri passato corrisponda a quello della
                 funzione data.
 PARAMETRI:   p_function_owner   user oracle proprietario
              p_firing_function  funzione da lanciare
 RITORNA:     number:   1 se valido,
                        0 altrimenti.
 NOTE:        --
******************************************************************************/
   d_isValidObj number := 0;
   d_parameters varchar2(4000);
   d_package    varchar2(30);
   d_function   varchar2(4000);
   d_db_link    varchar2(2000);
   c_overload   afc.t_ref_cursor;
   d_overload   number;
   d_statement  varchar2(32767);
begin
   get_function_attributes ( p_firing_function
                           , d_function
                           , d_package
                           , d_parameters
                           , d_db_link);
   --raise_application_error(-20999, d_function||' '||d_db_link);
   -- Controlla che esistano le grant per l'oggetto e che sia valido.
   d_statement :=
   'SELECT COUNT(1)
     FROM ALL_OBJECTS'||d_db_link||' ALOB
    WHERE ALOB.OBJECT_NAME = nvl('''||d_package||''', '''||d_function||''')
      AND ALOB.OWNER = '''||p_function_owner||'''
      AND ALOB.STATUS = ''VALID''
      AND ALOB.OBJECT_TYPE = DECODE(ALOB.OBJECT_TYPE, ''PACKAGE BODY'', ''PACKAGE'', ALOB.OBJECT_TYPE)';
   integritypackage.log(d_statement);
   EXECUTE IMMEDIATE d_statement INTO d_isValidObj;
   -- se è un package controlla che contenga la funzione specificata
   IF d_isValidObj > 0 AND d_package IS NOT NULL THEN
      d_statement :=
      'SELECT COUNT(1)
        FROM all_ARGUMENTS'||d_db_link||'
       WHERE OWNER = '''||p_function_owner||'''
         AND PACKAGE_NAME = '''||d_package||'''
         AND OBJECT_NAME = '''||d_function||''''
      ;
      integritypackage.log(d_statement);
      EXECUTE IMMEDIATE d_statement INTO d_isValidObj;
   END IF;
   -- controlla che il numero di parametri passato corrisponda a quello della
   -- funzione data.
   IF d_isValidObj > 0 THEN
      DECLARE
         d_countGivenArgs  number;
         d_countArgs number;
      BEGIN
         d_isValidObj := 0;
         if d_parameters is not null then
            d_countGivenArgs := afc.CountOccurrenceOf(d_parameters, ',') + 1;
         else
            d_countGivenArgs := 0;
         end if;
         d_statement :=
            'select distinct NVL(overload, -1) overload
               from ALL_ARGUMENTS'||d_db_link||'
              WHERE OWNER = '''||p_function_owner||'''
                AND nvl(PACKAGE_NAME, ''xxx'') = DECODE('''||d_package||''', to_char(null), ''xxx'', '''||d_package||''')
                AND OBJECT_NAME = '''||d_function||'''';
         integritypackage.log(d_statement);
         open c_overload for d_statement;
         loop
            fetch c_overload into d_overload;
            exit when c_overload%notfound;
            d_statement :=
            'SELECT COUNT(1)
              FROM ALL_ARGUMENTS'||d_db_link||'
             WHERE OWNER = '''||p_function_owner||'''
               AND nvl(PACKAGE_NAME, ''xxx'') = DECODE('''||d_package||''', to_char(null), ''xxx'', '''||d_package||''')
               AND OBJECT_NAME = '''||d_function||'''
               AND ARGUMENT_NAME IS NOT NULL
               AND NVL(overload, -1) = '||d_overload
            ;
            integritypackage.log(d_statement);
            EXECUTE IMMEDIATE d_statement INTO d_countArgs;
            if d_countArgs = d_countGivenArgs then
               d_isValidObj := 1;
               EXIT;
            end if;
         end loop;
         close c_overload;
      END;
   END IF;
   return  d_isValidObj;
end is_valid_function;
PROCEDURE crea_trigger_si4ef
( p_table_name in varchar2
, p_check_esiste in number default 1)
is
/******************************************************************************
 NOME:        crea_trigger_si4ef
 DESCRIZIONE: Crea trigger di AFTER DELETE OR INSERT OR UPDATE sulla tabella
              data.
              Il trigger lancia tutte le funzioni esterne previste per la
              tabella.
 PARAMETRI:   p_table_name       tabella su cui creare il trigger
              p_check_esiste     se = 1 crea il trigger solo se non esiste
                                 se = 0 crea il trigger anche se esiste gia'
 NOTE:        --
******************************************************************************/
   d_esiste number;
   d_sql varchar2(32767);
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
   d_esiste := p_check_esiste;
   if p_check_esiste = 1 then
      select count(1)
        into d_esiste
        from user_triggers
       where trigger_name = substr(p_table_name, 1, 18) ||'_SI4EF_TAIUD'
      ;
   end if;
   if d_esiste = 0 then
      d_sql := 'CREATE OR REPLACE TRIGGER '|| substr(p_table_name, 1, 21) ||'_EF_TAIUD '||
               'AFTER DELETE OR INSERT OR UPDATE '||
               'ON '|| p_table_name ||' '||
               'FOR EACH ROW '||
               'DECLARE '||
               '   d_function varchar2(4000); '||
               '   d_lancia boolean := FALSE; '||
               '   d_statement  varchar2(32000); '||
               '   d_slave_stato varchar2(1) := ''A''; '||
               '   d_db_link    varchar2(2000); '||
               'BEGIN '||
               '   for c_exfu in (select FUNCTION_OWNER, decode(substr(FIRING_FUNCTION, -1, 1), '';'', substr(FIRING_FUNCTION, 1, length(FIRING_FUNCTION) - 1), FIRING_FUNCTION) FIRING_FUNCTION, FIRING_EVENT, external_functions_pkg.get_return_type(FUNCTION_OWNER, FIRING_FUNCTION) RETURN_TYPE  '||
               '                    from external_functions '||
               '                   where table_name = '''|| p_table_name ||''') '||
               '   loop '||
               '      d_lancia := (inserting and c_exfu.FIRING_EVENT = ''I'') '||
               '               or (deleting  and c_exfu.FIRING_EVENT = ''D'') '||
               '               or (updating  and c_exfu.FIRING_EVENT = ''U''); '||
               '      if d_lancia then '||
               '         d_function := c_exfu.FIRING_FUNCTION; '||
               '         d_db_link := external_functions_pkg.get_db_link ( d_function ); '||
               '         if d_db_link is not null then '||
               '           begin '||
               '              select stato '||
               '                into d_slave_stato '||
               '                from ad4_slaves '||
               '               where db_link = ltrim(d_db_link, ''@''); '||
               '           exception when no_data_found then '||
               '              d_slave_stato := ''A''; '||
               '           end; '||
               '        end if; '||
               '        if d_slave_stato = ''A'' then '
               ;
      FOR COLS IN (SELECT COLUMN_NAME, DATA_TYPE
                     FROM USER_TAB_COLUMNS
                    WHERE TABLE_NAME = p_table_name
                 order by COLUMN_NAME desc )
      LOOP
         IF COLS.DATA_TYPE LIKE '%CHAR%' THEN
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':NEW.'||COLS.COLUMN_NAME||''',''''''''||REPLACE(:NEW.'||COLS.COLUMN_NAME||','''''''','''''''''''')||''''''''); ';
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':OLD.'||COLS.COLUMN_NAME||''',''''''''||REPLACE(:OLD.'||COLS.COLUMN_NAME||','''''''','''''''''''')||''''''''); ';
         ELSIF COLS.DATA_TYPE = 'NUMBER' THEN
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':NEW.'||COLS.COLUMN_NAME||''',''to_number(''''''||:NEW.'||COLS.COLUMN_NAME||'||'''''')''); ';
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':OLD.'||COLS.COLUMN_NAME||''',''to_number(''''''||:OLD.'||COLS.COLUMN_NAME||'||'''''')''); ';
         ELSIF COLS.DATA_TYPE = 'DATE' THEN
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':NEW.'||COLS.COLUMN_NAME||''',''to_date(''''''||to_char(:NEW.'||COLS.COLUMN_NAME||',''dd/mm/yyyy hh24:mi:ss'')||'''''',''''dd/mm/yyyy hh24:mi:ss'''')''); ';
            d_sql := d_sql ||
               '         c_exfu.FIRING_FUNCTION := replace(c_exfu.FIRING_FUNCTION, '':OLD.'||COLS.COLUMN_NAME||''',''to_date(''''''||to_char(:OLD.'||COLS.COLUMN_NAME||',''dd/mm/yyyy hh24:mi:ss'')||'''''',''''dd/mm/yyyy hh24:mi:ss'''')''); ';
         END IF;
      END LOOP;
      d_sql := d_sql ||
               '           if c_exfu.RETURN_TYPE is not null then '||
               '              d_statement := ''declare d_ret varchar2(4000); begin d_ret := ''; '||
               '              if c_exfu.RETURN_TYPE not like ''%CHAR%'' then '||
               '                 d_statement := d_statement||'' to_char(''||c_exfu.FUNCTION_OWNER||''.''||c_exfu.FIRING_FUNCTION||'')''; '||
               '              else '||
               '                 d_statement := d_statement||c_exfu.FUNCTION_OWNER||''.''||c_exfu.FIRING_FUNCTION; '||
               '              end if; '||
               '           else '||
               '              d_statement := ''begin ''|| c_exfu.FUNCTION_OWNER||''.''||c_exfu.FIRING_FUNCTION; '||
               '           end if; '||
               '           d_statement := d_statement ||''; end;''; '||
               '           declare '||
               '              d_sqlerrm varchar2(2000); '||
               '           begin '||
               '              afc.SQL_EXECUTE(d_statement); '||
               '           exception '||
               '              when others then '||
               '                 raise;'||
               '            end; '||
               '         end if; '||
               '      end if; '||
               '   end loop; '||
               'EXCEPTION '||
               '   WHEN OTHERS THEN '||
               '      raise;'||
               'END; ';
      afc.sql_execute(d_sql);
   end if;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
end crea_trigger_si4ef;
PROCEDURE elimina_trigger_si4ef
( p_table_name in varchar2
, p_function_id in number default 0
, p_check_altri_record in number default 1)
is
/******************************************************************************
 NOME:        elimina_trigger_si4ef
 DESCRIZIONE: Crea trigger di AFTER DELETE OR INSERT OR UPDATE sulla tabella
              data.
              Il trigger lancia tutte le funzioni esterne previste per la
              tabella.
 PARAMETRI:   p_table_name          tabella per cui eliminare il trigger
              p_function_id         id assegnato alla funzione
              p_check_altri_record  se = 1 elimina solo se, per la tabella data,
                                           non esistono altre funzioni esterne
                                           da lanciare.
                                 se = 0    elimina il trigger comunque.
 NOTE:        --
******************************************************************************/
   d_esiste number;
   d_sql varchar2(32767);
   PRAGMA AUTONOMOUS_TRANSACTION;
begin
   select count(1)
     into d_esiste
     from user_triggers
    where trigger_name = substr(p_table_name, 1, 18) ||'_EF_TAIUD'
   ;
   if d_esiste > 0 then
      d_esiste := p_check_altri_record;
      if p_check_altri_record = 1 then
         select count(1)
           into d_esiste
           from external_functions
          where table_name = p_table_name
            and function_id <> p_function_id
         ;
      end if;
      if d_esiste = 0 then
         d_sql := 'DROP TRIGGER '|| substr(p_table_name, 1, 18) ||'_SI4EF_TAIUD ';
         afc.sql_execute(d_sql);
      end if;
   end if;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
end elimina_trigger_si4ef;
--------------------------------------------------------------------------------
end external_functions_pkg;
/

