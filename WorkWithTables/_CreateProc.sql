
-- Проверка логина
create or replace function auth(
	_login CHARACTER VARYING(50),
	_password CHARACTER VARYING(50)
) 
returns BOOLEAN AS
$BODY$
begin

	IF EXISTS (SELECT FROM users WHERE login = _login AND password = _password) THEN
		return TRUE;
	ELSE
		return FALSE;
	END IF;
	
end;
$BODY$
LANGUAGE plpgsql;



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
	-- (202,'roles'),
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





--Добавление пассажира
create or replace function add_passengers(
	_last_name CHARACTER VARYING(20),
	_first_name CHARACTER VARYING(20),
	_is_male bit,
	_category_id INTEGER,
	_is_EKS bit,
	_user_id INTEGER,
	_middle_name CHARACTER VARYING(20) default null,
	_phone_info  CHARACTER VARYING(1000) default null,
	_add_info CHARACTER VARYING(1000) default null
)
returns INTEGER AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (208,'passengers'),
	_table_id INTEGER default(208);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	INSERT INTO public.passengers(last_name, first_name, middle_name, is_male, category_id, is_eks, phone_info, add_info) 
		VALUES (_last_name, _first_name, _middle_name, _is_male, _category_id, _is_eks, _phone_info, _add_info)
		RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select 
			  _last_name as last_name
			, _first_name as first_name
			, _middle_name as middle_name
			, _is_male as is_male
			, _category_id as category_id
			, _is_eks as is_eks
			, _phone_info as phone_info
			, _add_info as add_info	
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
