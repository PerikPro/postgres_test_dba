-- TEST min_max    
    
SELECT min(val) || '->' ||  max(val) FROM (VALUES(5),(3),(6),(7),(9),(10),(7)) t(val);
SELECT val FROM (VALUES(5),(3),(6),(7),(9),(10),(7)) t(val);

-- FUNCTION transition min_to_max_func
create or replace function min_to_max_func(val bigint[], cval integer) returns bigint[] 
language plpgsql
as $$
declare
   answer bigint[];
begin
   answer[1] = least(cval, val[1]);
   answer[2] = greatest(cval, val[2]);
return answer;
end; 
$$;

-- FUNCTION transition min_to_max_func
create or replace function min_to_max_final(val bigint[]) returns varchar
language plpgsql
as $$
begin
    return val[1] || ' -> ' || val[2];
end; 
$$;


-- AGGREAGATE min_to_max
create or replace  aggregate  min_to_max(val integer)
    (
      sfunc = min_to_max_func,                 
      stype = bigint[],
      finalfunc = min_to_max_final
    ); 

---------------------------------------
SELECT  min_to_max(val) FROM (VALUES(5),(3),(6),(7),(9),(15),(7)) t(val);

DROP AGGREGATE min_to_max(integer)
DROP FUNCTION min_to_max_func(integer)
