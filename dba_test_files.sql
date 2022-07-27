-- TEST min_max    
    
SELECT min(val) || '->' ||  max(val) FROM (VALUES(5),(3),(6),(7),(9),(10),(7)) t(val);
SELECT val FROM (VALUES(5),(3),(6),(7),(9),(10),(7)) t(val);


-- FUNCTION transition min_to_max_func
create or replace function min_to_max_func(val int[], cval integer) returns int[] 
language plpgsql
as $$
declare
   answer int[];
begin
   answer[1] = least(cval, val[1]);
   answer[2] = greatest(cval, val[2]);
return answer;
end; 
$$;

-- FUNCTION final min_to_max_final
create or replace function min_to_max_final(val int[]) returns varchar
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
      stype = int[],
      finalfunc = min_to_max_final
    ); 

---------------------------------------
SELECT  min_to_max(val) FROM (VALUES(5),(3),(6),(7),(9),(19),(7),(2)) t(val);

