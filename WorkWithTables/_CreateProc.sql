--Добавление пассажира
create or replace procedure add_passengers(
	_name CHARACTER VARYING(50),
	_full_name CHARACTER VARYING(100),
	_is_male bit,
	_category CHARACTER VARYING(12),
	_is_EKS bit,
	_create_user_id INTEGER,
	_add_info CHARACTER VARYING(1000) default null
)
language plpgsql    
as $BODY$
begin
	
    -- добавляем данные в пассажира
    INSERT INTO public.passengers
		( name, full_name, is_male, category, add_info, is_eks, create_time, create_user_id)
	VALUES
		( _name, _full_name, _is_male, _category, _add_info, _is_eks, now(), _create_user_id)	
	RETURNING id;

    commit;
end;
$BODY$;



-- Создание роли
create or replace function create_roles(
	_name CHARACTER VARYING(50),
	_user_id INTEGER
) 
returns integer AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- table Roles in Tables - 202 id
	_table_id INTEGER default(202);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	INSERT INTO public.roles(name) 
		VALUES (_name)
		RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select _name as name	
	)
		
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _id, _jsonb, now(), _user_id);

	return _id;
end;
$BODY$
LANGUAGE plpgsql;




-- Проверка логина
create or replace function auth(
	_login CHARACTER VARYING(50),
	_password CHARACTER VARYING(50)
) 
returns BOOLEAN AS
$BODY$
begin

	IF EXISTS (SELECT FROM users WHERE login = _login AND password = _password) THEN
		return true;
	ELSE
		return FALSE;
	END IF;
	
end;
$BODY$
LANGUAGE plpgsql;