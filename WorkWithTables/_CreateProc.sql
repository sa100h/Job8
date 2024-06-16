
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




--Обновление пассажира
create or replace function update_passengers(
	_user_id INTEGER,
	_pas_id  INTEGER,
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
	-- (208,'passengers'),
	_table_id INTEGER default(208);
	-- (2,'Редактирование'),
	_oper_type_id INTEGER default(2);
begin
	
	UPDATE public.passengers
	SET 
		  last_name= _last_name
		, first_name= _first_name
		, middle_name= _middle_name
		, is_male= _is_male
		, category_id= _category_id
		, is_eks= _is_eks
		, phone_info= _phone_info
		, add_info= _add_info
	WHERE id = _pas_id;

	with
	update_data as
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
	from update_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _pas_id, _jsonb, now(), _user_id);

	return _pas_id;
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





------------------------------
SELECT 
	public.add_bid(
	_user_id => 1,
	_status_id => 1,
	_pas_id => 389,
	_count_pass => 4,
	_category_id => 1,
	_start_time => TO_TIMESTAMP('24.06.2024 15:00:00', 'DD.MM.YYYY HH24:MI:SS')::timestamp,
	_st_beg_id => 1,
	_st_end_id => 15,
	_execution_time => '02:00:00'::time,
	_number_all => 6,
	_acceptance_method_id => 1,
	_is_need_help => 0::bit,
	_employee_ids => ARRAY [3,4,8],
	_baggage_type => '_baggage_type',
	_baggage_weight => '_baggage_weight',
	_st_beg_desc => '_st_beg_desc',
	_st_end_desc => '_st_end_desc' ,
	_number_sex_m => 3 ,
	_number_sex_f =>1 
)









CREATE OR REPLACE FUNCTION public.add_bid(
	_user_id integer,
	_status_id integer,
	_pas_id integer,
	_count_pass integer,
	_category_id integer,
	_start_time timestamp without time zone,
	_st_beg_id integer,
	_st_end_id integer,
	_execution_time time without time zone,
	_number_all integer,
	_acceptance_method_id integer,
	_is_need_help bit,
	_employee_work_ids integer[] DEFAULT NULL,
	_baggage_type character varying DEFAULT NULL,
	_baggage_weight character varying DEFAULT NULL,
	_st_beg_desc character varying DEFAULT NULL,
	_st_end_desc character varying DEFAULT NULL,
	_number_sex_m integer DEFAULT NULL,
	_number_sex_f integer DEFAULT NULL)
    RETURNS integer
AS $BODY$
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
			, _employee_work_ids as employee_work_ids
	)
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _id, _jsonb, now(), _user_id);
		
	with
	employee_on_bid as
	(
		SELECT
			  _id as bid_id
			, UNNEST(_employee_work_ids) as employee_work_id
			, 1::bit as is_automatic
			, FALSE as is_deleted
	)
	INSERT INTO employee_on_bids (bid_id, employee_work_id, is_automatic, is_deleted)
	select
		  bid_id
		, employee_work_id
		, is_automatic
		, is_deleted
	from employee_on_bid;
	
	
	return _id;
end;

$BODY$
LANGUAGE plpgsql;







-- Создание пользователя

-- Создание пользователя
create or replace function create_user(
	_user_id INTEGER,
	_login CHARACTER VARYING(50),
	_password CHARACTER VARYING(50),
	_last_name CHARACTER VARYING(20),
	_first_name CHARACTER VARYING(20),
	_middle_name CHARACTER VARYING(20)
) 
returns integer AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (201	"users"),
	_table_id INTEGER default(201);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	INSERT INTO public.users(login, password, last_name, first_name, middle_name) 
		VALUES (_login, _password, _last_name, _first_name, _middle_name)
		RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select 
			  _login as login
			, _password as password 
			, _last_name as last_name
			, _first_name as first_name
			, _middle_name as middle_name	
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




-- Создание работы сотрудника
create or replace function create_employee_work(
	_user_id INTEGER,
	_employee_id INTEGER,
	_rank_id INTEGER, 
	_shift_id INTEGER, 
	_area_id INTEGER, 
	_work_phone character varying(12), 
	_start_time time without time zone , 
	_end_time time without time zone , 
	_only_light_work bit
) 
returns integer AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (206	"employee_works"),
	_table_id INTEGER default(206);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	INSERT INTO public.employee_works
	(employee_id, rank_id, shift_id, area_id, work_phone, start_time, end_time, only_light_work) 
		VALUES (_employee_id, _rank_id, _shift_id, _area_id, _work_phone, _start_time, _end_time, _only_light_work)
		RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select 
			  _employee_id as employee_id
			, _rank_id as rank_id
			, _shift_id as shift_id
			, _area_id as area_id
			, _work_phone as work_phone
			, _start_time as start_time
			, _end_time as end_time
			, _only_light_work as only_light_work
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





-- Создание сотрудника
create or replace function create_employee(
	_user_id INTEGER,
	_login CHARACTER VARYING(50),
	_password CHARACTER VARYING(50),
	_last_name CHARACTER VARYING(20),
	_first_name CHARACTER VARYING(20),
	_middle_name CHARACTER VARYING(20),
	
	_personnel_number CHARACTER VARYING(8),
	_is_male bit,
	_person_phone CHARACTER VARYING(12),

	_rank_id INTEGER, 
	_shift_id INTEGER, 
	_area_id INTEGER, 
	_work_phone character varying(12), 
	_start_time time without time zone , 
	_end_time time without time zone , 
	_only_light_work bit
) 
returns integer AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (205	"employees"),
	_table_id INTEGER default(205);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	SELECT public.create_user(
		_user_id=>_user_id,
		_login=>_login,
		_password=>_password,
		_last_name=>_last_name,
		_first_name=>_first_name,
		_middle_name=>_middle_name)
	INTO _id;
	
	INSERT INTO public.users(user_id, personnel_number, is_male, person_phone) 
		VALUES (_id, _personnel_number, _is_male, _person_phone);

	with
	inst_data as
	(
		select 
			  _id as user_id
			, _personnel_number as personnel_number  
			, _is_male as is_male
			, _person_phone	 as person_phone
	)
		
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _id, _jsonb, now(), _user_id);

	SELECT public.create_employee_work(
		  _user_id => _id
		, _employee_id => _employee_id
		, _rank_id => _rank_id
		, _shift_id => _shift_id
		, _area_id => _area_id
		, _work_phone => _work_phone
		, _start_time =>_start_time
		, _end_time => _end_time
		, _only_light_work => _only_light_work
	);
	
	return _id;
end;
$BODY$
LANGUAGE plpgsql;








-- Создание рабочего дня сотруднику
create or replace function create_working_day(
	_user_id INTEGER,

	_employee_work_id INTEGER,
	_shift_date date,
	_is_additional_day bit,
	_start_time time without time zone,
	_end_time time without time zone,
	_is_other_work_time bit
) 
returns integer AS
$BODY$
declare 
	_jsonb jsonb;
	_id INTEGER;
	-- (207	"working_days"),
	_table_id INTEGER default(207);
	-- (1,'Создание'),
	_oper_type_id INTEGER default(1);
begin
	
	INSERT INTO public.working_days
		(employee_work_id,shift_date,is_additional_day,start_time,end_time,is_other_work_time) 
		VALUES (_employee_work_id,_shift_date,_is_additional_day,_start_time,_end_time,_is_other_work_time)
		RETURNING id
		INTO _id;

	with
	inst_data as
	(
		select 
			  _employee_work_id as employee_work_id
		 	, _shift_date as shift_date
			, _is_additional_day as is_additional_day
			, _start_time as start_time
			, _end_time as end_time
			, _is_other_work_time as is_other_work_time
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


