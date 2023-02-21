CREATE OR REPLACE function DOCU_ESISTE
( p_anno                    number
, p_numero                  number
, p_registro                varchar2) 
return varchar2 as
  v_count                   number(8);
  v_ritorno                 varchar2(2);
begin
  select count(*)
    into v_count
    from DOCUMENTI A
   where A.anno = p_anno
     and A.numero = p_numero
     and A.tipo_registro = p_registro;
--
  if v_count > 0 then
     v_ritorno := 'SI';
  else
     v_ritorno := 'NO';
  end if;
--
  return v_ritorno;
end;
/

