

------Только для теста



CREATE OR REPLACE FUNCTION public.Test1(
	_employee_ids integer[] DEFAULT NULL
	)
    RETURNS jsonb
AS $BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (209,'bids'),
	_table_id INTEGER default(209);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	
	with
	inst_data as
	(
		select 
			UNNEST(_employee_ids) as _employee_id
	)
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;
		
	return _jsonb;
end;

$BODY$
LANGUAGE plpgsql;
