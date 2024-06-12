
-- Проверка логина и пароля 
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
	_user_id INTEGER,
	_name CHARACTER VARYING(50)
	
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
	_user_id INTEGER,
	_last_name CHARACTER VARYING(20),
	_first_name CHARACTER VARYING(20),
	_is_male bit,
	_category_id INTEGER,
	_is_EKS bit,
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







--Добавление заявки
create or replace function add_bid(
	_user_id INTEGER,
	_status_id INTEGER,
	_pas_id INTEGER,
	_count_pass INTEGER,
	_category_id INTEGER,
	_start_time timestamp,
	_st_beg_id INTEGER,
	_st_end_id INTEGER,
	_execution_time time,
	_number_all INTEGER,
	_acceptance_method_id INTEGER,
	_is_need_help bit,
	_employee_ids INTEGER[] default null,
	_baggage_type CHARACTER VARYING(50) default null,
	_baggage_weight CHARACTER VARYING(50) default null,
	_st_beg_desc CHARACTER VARYING(150)  default null,
	_st_end_desc CHARACTER VARYING(150) default null,
	_number_sex_m INTEGER default null,
	_number_sex_f INTEGER default null
)
returns INTEGER AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (209,'bids'),
	_table_id INTEGER default(209);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	INSERT INTO 
		public.bids(pas_id, count_pass, category_id, baggage_type, baggage_weight, is_need_help
				  , st_beg_id, st_beg_desc, st_end_id, st_end_desc, start_time
				  , status_id, number_all, number_sex_m, number_sex_f
				  , execution_time, acceptance_method_id)
		VALUES (_pas_id, _count_pass, _category_id, _baggage_type, _baggage_weight, _is_need_help
				  , _st_beg_id, _st_beg_desc, _st_end_id, _st_end_desc, _start_time
				  , _status_id, _number_all, _number_sex_m, _number_sex_f
				  , _execution_time, _acceptance_method_id)
	RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select 
			  _pas_id as pas_id
			, _count_pass as count_pass
			, _category_id as category_id
			, _baggage_type as baggage_type
			, _baggage_weight as baggage_weight
			, _is_need_help as is_need_help
		  	, _st_beg_id as st_beg_id
			, _st_beg_desc as st_beg_desc
			, _st_end_id as st_end_id
			, _st_end_desc as st_end_desc
			, _start_time as start_time
			, _status_id as status_id
			, _number_all as number_all
			, _number_sex_m as number_sex_m 
			, _number_sex_f as number_sex_f
		  	, _execution_time as execution_time
			, _acceptance_method_id as acceptance_method_id
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




--Редактирование заявки
create or replace function edit_bid(
	_user_id INTEGER,
	_bid_id INTEGER,
	_status_id INTEGER,
	_count_pass INTEGER,
	_category_id INTEGER,
	_start_time timestamp,
	_st_beg_id INTEGER,
	_st_end_id INTEGER,
	_execution_time time,
	_number_all INTEGER,
	_acceptance_method_id INTEGER,
	
	_is_need_help bit,
	_baggage_type CHARACTER VARYING(50) default null,
	_baggage_weight CHARACTER VARYING(50) default null,
	_st_beg_desc CHARACTER VARYING(150)  default null,
	_st_end_desc CHARACTER VARYING(150) default null,
	_number_sex_m INTEGER default null,
	_number_sex_f INTEGER default null
)
returns INTEGER AS
$BODY$
declare 
	_jsonb jsonb;
	-- (209,'bids'),
	_table_id INTEGER default(209);
	-- (2,'Редактирование'),
	_oper_type_id INTEGER default(2);
begin
	update public.bids
		set 
		  count_pass = _count_pass
		, category_id = _category_id
		, baggage_type = _baggage_type
		, baggage_weight = _baggage_weight
		, is_need_help = _is_need_help
		, st_beg_id = _st_beg_id
		, st_beg_desc = _st_beg_desc
		, st_end_id = _st_end_id
		, st_end_desc = _st_end_desc
		, start_time = _start_time
		, status_id = _status_id
		, number_all = _number_all
		, number_sex_m = _number_sex_m
		, number_sex_f = _number_sex_f
		, execution_time = _execution_time
		, acceptance_method_id = _acceptance_method_id
	where id = _bid_id;

	with
	inst_data as
	(
		select 
			  _count_pass as count_pass
			, _category_id as category_id
			, _baggage_type as baggage_type
			, _baggage_weight as baggage_weight
			, _is_need_help as is_need_help
		  	, _st_beg_id as st_beg_id
			, _st_beg_desc as st_beg_desc
			, _st_end_id as st_end_id
			, _st_end_desc as st_end_desc
			, _start_time as start_time
			, _status_id as status_id
			, _number_all as number_all
			, _number_sex_m as number_sex_m 
			, _number_sex_f as number_sex_f
		  	, _execution_time as execution_time
			, _acceptance_method_id as acceptance_method_id
	)
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _bid_id, _jsonb, now(), _user_id);

	return _bid_id;
end;
$BODY$
LANGUAGE plpgsql;
