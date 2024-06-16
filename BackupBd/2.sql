PGDMP                        |            Dep_Trans_02     16.3 (Ubuntu 16.3-1.pgdg22.04+1)    16.3 �    G           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            H           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            I           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            J           1262    18053    Dep_Trans_02    DATABASE     v   CREATE DATABASE "Dep_Trans_02" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE "Dep_Trans_02";
                postgres    false            (           1255    18878 �   add_bid(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer, time without time zone, integer, integer, bit, integer[], character varying, character varying, character varying, character varying, integer, integer)    FUNCTION     �
  CREATE FUNCTION public.add_bid(_user_id integer, _status_id integer, _pas_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _employee_work_ids integer[] DEFAULT NULL::integer[], _baggage_type character varying DEFAULT NULL::character varying, _baggage_weight character varying DEFAULT NULL::character varying, _st_beg_desc character varying DEFAULT NULL::character varying, _st_end_desc character varying DEFAULT NULL::character varying, _number_sex_m integer DEFAULT NULL::integer, _number_sex_f integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
			, 0::bit as is_automatic
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

$$;
   DROP FUNCTION public.add_bid(_user_id integer, _status_id integer, _pas_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _employee_work_ids integer[], _baggage_type character varying, _baggage_weight character varying, _st_beg_desc character varying, _st_end_desc character varying, _number_sex_m integer, _number_sex_f integer);
       public          postgres    false            #           1255    18849 �   add_passengers(integer, character varying, character varying, bit, integer, bit, character varying, character varying, character varying)    FUNCTION     B  CREATE FUNCTION public.add_passengers(_user_id integer, _last_name character varying, _first_name character varying, _is_male bit, _category_id integer, _is_eks bit, _middle_name character varying DEFAULT NULL::character varying, _phone_info character varying DEFAULT NULL::character varying, _add_info character varying DEFAULT NULL::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
   DROP FUNCTION public.add_passengers(_user_id integer, _last_name character varying, _first_name character varying, _is_male bit, _category_id integer, _is_eks bit, _middle_name character varying, _phone_info character varying, _add_info character varying);
       public          postgres    false                       1255    18847 *   auth(character varying, character varying)    FUNCTION       CREATE FUNCTION public.auth(_login character varying, _password character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
begin

	IF EXISTS (SELECT FROM users WHERE login = _login AND password = _password) THEN
		return TRUE;
	ELSE
		return FALSE;
	END IF;
	
end;
$$;
 R   DROP FUNCTION public.auth(_login character varying, _password character varying);
       public          postgres    false            &           1255    18908   create_employee(integer, character varying, character varying, character varying, character varying, character varying, character varying, bit, character varying, integer, integer, integer, character varying, time without time zone, time without time zone, bit)    FUNCTION     �  CREATE FUNCTION public.create_employee(_user_id integer, _login character varying, _password character varying, _last_name character varying, _first_name character varying, _middle_name character varying, _personnel_number character varying, _is_male bit, _person_phone character varying, _rank_id integer, _shift_id integer, _area_id integer, _work_phone character varying, _start_time time without time zone, _end_time time without time zone, _only_light_work bit) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 �  DROP FUNCTION public.create_employee(_user_id integer, _login character varying, _password character varying, _last_name character varying, _first_name character varying, _middle_name character varying, _personnel_number character varying, _is_male bit, _person_phone character varying, _rank_id integer, _shift_id integer, _area_id integer, _work_phone character varying, _start_time time without time zone, _end_time time without time zone, _only_light_work bit);
       public          postgres    false            "           1255    18906 �   create_employee_work(integer, integer, integer, integer, integer, character varying, time without time zone, time without time zone, bit)    FUNCTION       CREATE FUNCTION public.create_employee_work(_user_id integer, _employee_id integer, _rank_id integer, _shift_id integer, _area_id integer, _work_phone character varying, _start_time time without time zone, _end_time time without time zone, _only_light_work bit) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
   DROP FUNCTION public.create_employee_work(_user_id integer, _employee_id integer, _rank_id integer, _shift_id integer, _area_id integer, _work_phone character varying, _start_time time without time zone, _end_time time without time zone, _only_light_work bit);
       public          postgres    false                       1255    18848 (   create_roles(integer, character varying)    FUNCTION     �  CREATE FUNCTION public.create_roles(_user_id integer, _name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 N   DROP FUNCTION public.create_roles(_user_id integer, _name character varying);
       public          postgres    false                       1255    18905 s   create_user(integer, character varying, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.create_user(_user_id integer, _login character varying, _password character varying, _last_name character varying, _first_name character varying, _middle_name character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 �   DROP FUNCTION public.create_user(_user_id integer, _login character varying, _password character varying, _last_name character varying, _first_name character varying, _middle_name character varying);
       public          postgres    false            '           1255    18910 d   create_working_day(integer, integer, date, bit, time without time zone, time without time zone, bit)    FUNCTION     �  CREATE FUNCTION public.create_working_day(_user_id integer, _employee_work_id integer, _shift_date date, _is_additional_day bit, _start_time time without time zone, _end_time time without time zone, _is_other_work_time bit) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 �   DROP FUNCTION public.create_working_day(_user_id integer, _employee_work_id integer, _shift_date date, _is_additional_day bit, _start_time time without time zone, _end_time time without time zone, _is_other_work_time bit);
       public          postgres    false            $           1255    18851 �   edit_bid(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer, time without time zone, integer, integer, bit, character varying, character varying, character varying, character varying, integer, integer)    FUNCTION     �  CREATE FUNCTION public.edit_bid(_user_id integer, _bid_id integer, _status_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _baggage_type character varying DEFAULT NULL::character varying, _baggage_weight character varying DEFAULT NULL::character varying, _st_beg_desc character varying DEFAULT NULL::character varying, _st_end_desc character varying DEFAULT NULL::character varying, _number_sex_m integer DEFAULT NULL::integer, _number_sex_f integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 �  DROP FUNCTION public.edit_bid(_user_id integer, _bid_id integer, _status_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _baggage_type character varying, _baggage_weight character varying, _st_beg_desc character varying, _st_end_desc character varying, _number_sex_m integer, _number_sex_f integer);
       public          postgres    false            )           1255    19281 �   edit_bid(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer, time without time zone, integer, integer, bit, integer[], character varying, character varying, character varying, character varying, integer, integer)    FUNCTION     �
  CREATE FUNCTION public.edit_bid(_user_id integer, _bid_id integer, _status_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _employee_work_ids integer[] DEFAULT NULL::integer[], _baggage_type character varying DEFAULT NULL::character varying, _baggage_weight character varying DEFAULT NULL::character varying, _st_beg_desc character varying DEFAULT NULL::character varying, _st_end_desc character varying DEFAULT NULL::character varying, _number_sex_m integer DEFAULT NULL::integer, _number_sex_f integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
			, _employee_work_ids as employee_work_ids
	)
	select
		 to_jsonb(json_agg(t))
	from inst_data t
	INTO _jsonb;

	INSERT INTO public.operations(table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) 
		VALUES (_table_id, _oper_type_id, _bid_id, _jsonb, now(), _user_id);
	
	with
	employee_on_bid as
	(
		SELECT
			  _id as bid_id
			, UNNEST(_employee_work_ids) as employee_work_id
			, 0::bit as is_automatic
			, FALSE as is_deleted
	)
	INSERT INTO employee_on_bids (bid_id, employee_work_id, is_automatic, is_deleted)
	select
		  bid_id
		, employee_work_id
		, is_automatic
		, is_deleted
	from employee_on_bid;
	
	return _bid_id;
end;
$$;
   DROP FUNCTION public.edit_bid(_user_id integer, _bid_id integer, _status_id integer, _count_pass integer, _category_id integer, _start_time timestamp without time zone, _st_beg_id integer, _st_end_id integer, _execution_time time without time zone, _number_all integer, _acceptance_method_id integer, _is_need_help bit, _employee_work_ids integer[], _baggage_type character varying, _baggage_weight character varying, _st_beg_desc character varying, _st_end_desc character varying, _number_sex_m integer, _number_sex_f integer);
       public          postgres    false                       1255    18813    get_inicial(character varying)    FUNCTION     �   CREATE FUNCTION public.get_inicial(_name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin

	IF _name IS NOT NULL THEN
		return substring(_name,1,1) || '.';
	ELSE
		return '';
	END IF;
	
end;
$$;
 ;   DROP FUNCTION public.get_inicial(_name character varying);
       public          postgres    false                       1255    18814 A   get_name(character varying, character varying, character varying)    FUNCTION       CREATE FUNCTION public.get_name(_last_name character varying, _first_name character varying, _middle_name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
begin

	return _last_name || ' ' || get_inicial(_first_name) || get_inicial(_middle_name);
	
end;
$$;
 |   DROP FUNCTION public.get_name(_last_name character varying, _first_name character varying, _middle_name character varying);
       public          postgres    false                       1255    18877    test1(integer[])    FUNCTION     �  CREATE FUNCTION public.test1(_employee_ids integer[] DEFAULT NULL::integer[]) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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

$$;
 5   DROP FUNCTION public.test1(_employee_ids integer[]);
       public          postgres    false            %           1255    18894 �   update_passengers(integer, integer, character varying, character varying, bit, integer, bit, character varying, character varying, character varying)    FUNCTION     j  CREATE FUNCTION public.update_passengers(_user_id integer, _pas_id integer, _last_name character varying, _first_name character varying, _is_male bit, _category_id integer, _is_eks bit, _middle_name character varying DEFAULT NULL::character varying, _phone_info character varying DEFAULT NULL::character varying, _add_info character varying DEFAULT NULL::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
   DROP FUNCTION public.update_passengers(_user_id integer, _pas_id integer, _last_name character varying, _first_name character varying, _is_male bit, _category_id integer, _is_eks bit, _middle_name character varying, _phone_info character varying, _add_info character varying);
       public          postgres    false                       1259    18890    _bid_trz    TABLE     Y   CREATE TABLE public._bid_trz (
    id integer,
    "time" timestamp without time zone
);
    DROP TABLE public._bid_trz;
       public         heap    postgres    false                       1259    18880    _names    TABLE     �   CREATE TABLE public._names (
    id integer NOT NULL,
    last_name character varying(50),
    first_name character varying(50),
    middle_name character varying(50),
    is_male boolean
);
    DROP TABLE public._names;
       public         heap    postgres    false                       1259    18879    _names_id_seq    SEQUENCE     �   CREATE SEQUENCE public._names_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public._names_id_seq;
       public          postgres    false    269            K           0    0    _names_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public._names_id_seq OWNED BY public._names.id;
          public          postgres    false    268            �            1259    18090    acceptance_methods    TABLE     m   CREATE TABLE public.acceptance_methods (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
 &   DROP TABLE public.acceptance_methods;
       public         heap    postgres    false            �            1259    18089    acceptance_methods_id_seq    SEQUENCE     �   CREATE SEQUENCE public.acceptance_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.acceptance_methods_id_seq;
       public          postgres    false    232            L           0    0    acceptance_methods_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.acceptance_methods_id_seq OWNED BY public.acceptance_methods.id;
          public          postgres    false    231            �            1259    18076    areas    TABLE     `   CREATE TABLE public.areas (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.areas;
       public         heap    postgres    false            �            1259    18075    areas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.areas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.areas_id_seq;
       public          postgres    false    228            M           0    0    areas_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.areas_id_seq OWNED BY public.areas.id;
          public          postgres    false    227            �            1259    18261    bids    TABLE     ]  CREATE TABLE public.bids (
    id integer NOT NULL,
    pas_id integer NOT NULL,
    count_pass integer NOT NULL,
    category_id integer NOT NULL,
    baggage_type character varying(50),
    baggage_weight character varying(50),
    is_need_help bit(1) NOT NULL,
    st_beg_id integer NOT NULL,
    st_beg_desc character varying(150),
    st_end_id integer NOT NULL,
    st_end_desc character varying(150),
    start_time timestamp without time zone NOT NULL,
    meeting_time time without time zone,
    completion_time time without time zone,
    status_id integer NOT NULL,
    number_all integer NOT NULL,
    number_sex_m integer,
    number_sex_f integer,
    execution_time time without time zone NOT NULL,
    acceptance_method_id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now(),
    additional_info character varying(1000)
);
    DROP TABLE public.bids;
       public         heap    postgres    false            �            1259    18260    bids_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bids_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.bids_id_seq;
       public          postgres    false    255            N           0    0    bids_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.bids_id_seq OWNED BY public.bids.id;
          public          postgres    false    254            �            1259    18069 
   categories    TABLE     �   CREATE TABLE public.categories (
    id integer NOT NULL,
    code character varying(3) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(100)
);
    DROP TABLE public.categories;
       public         heap    postgres    false            �            1259    18068    categories_id_seq    SEQUENCE     �   CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.categories_id_seq;
       public          postgres    false    226            O           0    0    categories_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;
          public          postgres    false    225                        1259    18297    employee_on_bids    TABLE     �   CREATE TABLE public.employee_on_bids (
    bid_id integer NOT NULL,
    employee_work_id integer NOT NULL,
    is_automatic bit(1) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);
 $   DROP TABLE public.employee_on_bids;
       public         heap    postgres    false            �            1259    18208    employee_works    TABLE     o  CREATE TABLE public.employee_works (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    rank_id integer NOT NULL,
    shift_id integer NOT NULL,
    area_id integer NOT NULL,
    work_phone character varying(12) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    only_light_work bit(1) NOT NULL
);
 "   DROP TABLE public.employee_works;
       public         heap    postgres    false            �            1259    18207    employee_works_id_seq    SEQUENCE     �   CREATE SEQUENCE public.employee_works_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.employee_works_id_seq;
       public          postgres    false    249            P           0    0    employee_works_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.employee_works_id_seq OWNED BY public.employee_works.id;
          public          postgres    false    248            �            1259    18197 	   employees    TABLE     �   CREATE TABLE public.employees (
    user_id integer NOT NULL,
    personnel_number character varying(8) NOT NULL,
    is_male bit(1) NOT NULL,
    person_phone character varying(12) NOT NULL
);
    DROP TABLE public.employees;
       public         heap    postgres    false            �            1259    18247 
   passengers    TABLE     i  CREATE TABLE public.passengers (
    id integer NOT NULL,
    last_name character varying(20) NOT NULL,
    first_name character varying(20) NOT NULL,
    middle_name character varying(20),
    is_male bit(1) NOT NULL,
    category_id integer NOT NULL,
    is_eks bit(1) NOT NULL,
    phone_info character varying(1000),
    add_info character varying(1000)
);
    DROP TABLE public.passengers;
       public         heap    postgres    false            �            1259    18062    statuses    TABLE     c   CREATE TABLE public.statuses (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.statuses;
       public         heap    postgres    false            �            1259    18156    users    TABLE       CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    last_name character varying(20) NOT NULL,
    first_name character varying(20) NOT NULL,
    middle_name character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false                       1259    18820    form_main_bid    VIEW     �  CREATE VIEW public.form_main_bid AS
 WITH bids_with_employees AS (
         SELECT eb.bid_id,
            public.get_name(u.last_name, u.first_name, u.middle_name) AS employee_name
           FROM ((public.employee_on_bids eb
             LEFT JOIN public.employee_works ew ON ((ew.id = eb.employee_work_id)))
             LEFT JOIN public.users u ON ((u.id = ew.employee_id)))
        ), bids_with_group_employees AS (
         SELECT bids_with_employees.bid_id,
            string_agg((bids_with_employees.employee_name)::text, ', '::text) AS employees
           FROM bids_with_employees
          GROUP BY bids_with_employees.bid_id
        ), bids_all AS (
         SELECT b.id AS number,
            b.start_time,
            public.get_name(p.last_name, p.first_name, p.middle_name) AS passenger,
            bge.employees,
            s.name AS status
           FROM (((public.bids b
             JOIN public.passengers p ON ((p.id = b.pas_id)))
             JOIN public.statuses s ON ((s.id = b.status_id)))
             LEFT JOIN bids_with_group_employees bge ON ((bge.bid_id = b.id)))
        )
 SELECT number,
    start_time,
    passenger,
    employees,
    status
   FROM bids_all;
     DROP VIEW public.form_main_bid;
       public          postgres    false    256    255    253    253    253    253    255    255    255    224    241    241    241    224    241    249    249    276    256                       1259    18815    form_main_passenger    VIEW     �  CREATE VIEW public.form_main_passenger AS
 SELECT p.id AS pas_id,
    p.last_name,
    p.first_name,
    p.middle_name,
    p.phone_info,
        CASE
            WHEN (p.is_male = (1)::bit(1)) THEN 'М'::text
            ELSE 'Ж'::text
        END AS sex,
    c.code AS category_code,
    p.is_eks,
    p.add_info
   FROM (public.passengers p
     JOIN public.categories c ON ((c.id = p.category_id)));
 &   DROP VIEW public.form_main_passenger;
       public          postgres    false    226    253    253    253    253    253    253    253    253    253    226            �            1259    18055    ranks    TABLE     `   CREATE TABLE public.ranks (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.ranks;
       public         heap    postgres    false            �            1259    18163    roles    TABLE     `   CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.roles;
       public         heap    postgres    false            �            1259    18169 
   user_roles    TABLE     _   CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);
    DROP TABLE public.user_roles;
       public         heap    postgres    false                       1259    18830    form_main_user_and_role    VIEW     4  CREATE VIEW public.form_main_user_and_role AS
 WITH emp_last_work AS (
         SELECT employee_works.employee_id,
            max(employee_works.id) AS id
           FROM public.employee_works
          GROUP BY employee_works.employee_id
        )
 SELECT u.id AS user_id,
    public.get_name(u.last_name, u.first_name, u.middle_name) AS user_name,
    u.login,
    u.password,
    ra.name AS rank_name,
    ro.name AS role_name
   FROM ((((((public.users u
     JOIN public.user_roles ur ON ((ur.user_id = u.id)))
     JOIN public.roles ro ON ((ro.id = ur.role_id)))
     LEFT JOIN public.employees e ON ((e.user_id = u.id)))
     LEFT JOIN emp_last_work elw ON ((elw.employee_id = e.user_id)))
     LEFT JOIN public.employee_works ew ON ((ew.id = elw.id)))
     LEFT JOIN public.ranks ra ON ((ra.id = ew.rank_id)));
 *   DROP VIEW public.form_main_user_and_role;
       public          postgres    false    244    222    222    241    241    241    241    241    241    243    243    244    247    249    249    249    276                       1259    18867    form_select_employee_in_bid    VIEW     �  CREATE VIEW public.form_select_employee_in_bid AS
 WITH emp_last_work AS (
         SELECT employee_works.employee_id,
            max(employee_works.id) AS id
           FROM public.employee_works
          GROUP BY employee_works.employee_id
        )
 SELECT ew.id,
    u.last_name,
    u.first_name,
    u.middle_name,
    a.name AS area_name,
    e.personnel_number
   FROM ((((((public.users u
     JOIN public.user_roles ur ON ((ur.user_id = u.id)))
     JOIN public.roles ro ON ((ro.id = ur.role_id)))
     JOIN public.employees e ON ((e.user_id = u.id)))
     LEFT JOIN emp_last_work elw ON ((elw.employee_id = e.user_id)))
     LEFT JOIN public.employee_works ew ON ((ew.id = elw.id)))
     LEFT JOIN public.areas a ON ((a.id = ew.area_id)));
 .   DROP VIEW public.form_select_employee_in_bid;
       public          postgres    false    244    228    228    241    241    241    241    243    249    249    249    247    247    244                       1259    19310    form_view_bid    VIEW       CREATE VIEW public.form_view_bid AS
 WITH bids_with_employees AS (
         SELECT eb.bid_id,
            ew.id AS employee_work_id
           FROM ((public.employee_on_bids eb
             LEFT JOIN public.employee_works ew ON ((ew.id = eb.employee_work_id)))
             LEFT JOIN public.users u ON ((u.id = ew.employee_id)))
        ), bids_with_group_employees AS (
         SELECT bids_with_employees.bid_id,
            array_agg(bids_with_employees.employee_work_id) AS employee_work_ids
           FROM bids_with_employees
          GROUP BY bids_with_employees.bid_id
        ), bids_all AS (
         SELECT b.id AS number,
            s.name AS status,
            b.pas_id,
            b.count_pass,
            c.code AS category_code,
            b.baggage_type,
            b.baggage_weight,
            b.is_need_help,
            b.start_time,
            b.st_beg_id,
            b.st_beg_desc,
            b.st_end_id,
            b.st_end_desc,
            b.number_all,
            b.number_sex_m,
            b.number_sex_f,
            bge.employee_work_ids,
            am.name AS acceptance_method,
            b.additional_info
           FROM (((((public.bids b
             JOIN public.form_main_passenger mp ON ((mp.pas_id = b.pas_id)))
             JOIN public.statuses s ON ((s.id = b.status_id)))
             JOIN public.categories c ON ((c.id = b.category_id)))
             JOIN public.acceptance_methods am ON ((am.id = b.acceptance_method_id)))
             LEFT JOIN bids_with_group_employees bge ON ((bge.bid_id = b.id)))
        )
 SELECT number,
    status,
    pas_id,
    count_pass,
    category_code,
    baggage_type,
    baggage_weight,
    is_need_help,
    start_time,
    st_beg_id,
    st_beg_desc,
    st_end_id,
    st_end_desc,
    number_all,
    number_sex_m,
    number_sex_f,
    employee_work_ids,
    acceptance_method,
    additional_info
   FROM bids_all;
     DROP VIEW public.form_view_bid;
       public          postgres    false    255    255    255    224    255    255    255    255    255    255    255    255    255    249    241    256    255    255    255    255    255    232    226    226    224    255    249    256    232    262            �            1259    18083    shifts    TABLE     a   CREATE TABLE public.shifts (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.shifts;
       public         heap    postgres    false            	           1259    18835    form_view_user_and_role    VIEW     �  CREATE VIEW public.form_view_user_and_role AS
 WITH emp_last_work AS (
         SELECT employee_works.employee_id,
            max(employee_works.id) AS id
           FROM public.employee_works
          GROUP BY employee_works.employee_id
        )
 SELECT u.id AS user_id,
    u.login,
    u.password,
    u.last_name,
    u.first_name,
    u.middle_name,
    ro.name AS role_name,
    ra.name AS rank_name,
    e.is_male,
    ew.work_phone,
    e.person_phone,
    s.name AS shift_name,
    ew.start_time,
    ew.end_time,
    e.personnel_number,
    ew.only_light_work
   FROM (((((((public.users u
     JOIN public.user_roles ur ON ((ur.user_id = u.id)))
     JOIN public.roles ro ON ((ro.id = ur.role_id)))
     LEFT JOIN public.employees e ON ((e.user_id = u.id)))
     LEFT JOIN emp_last_work elw ON ((elw.employee_id = e.user_id)))
     LEFT JOIN public.employee_works ew ON ((ew.id = elw.id)))
     LEFT JOIN public.ranks ra ON ((ra.id = ew.rank_id)))
     LEFT JOIN public.shifts s ON ((s.id = ew.shift_id)));
 *   DROP VIEW public.form_view_user_and_role;
       public          postgres    false    247    249    249    249    249    249    249    249    249    222    243    243    244    244    247    247    247    241    241    241    241    241    241    230    230    222            �            1259    18097    lines    TABLE     |   CREATE TABLE public.lines (
    id integer NOT NULL,
    name character varying(100),
    color_hex character varying(7)
);
    DROP TABLE public.lines;
       public         heap    postgres    false            �            1259    18096    lines_id_seq    SEQUENCE     �   CREATE SEQUENCE public.lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lines_id_seq;
       public          postgres    false    234            Q           0    0    lines_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.lines_id_seq OWNED BY public.lines.id;
          public          postgres    false    233                       1259    18320    operation_types    TABLE     j   CREATE TABLE public.operation_types (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
 #   DROP TABLE public.operation_types;
       public         heap    postgres    false                       1259    18319    operation_types_id_seq    SEQUENCE     �   CREATE SEQUENCE public.operation_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.operation_types_id_seq;
       public          postgres    false    259            R           0    0    operation_types_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.operation_types_id_seq OWNED BY public.operation_types.id;
          public          postgres    false    258                       1259    18329 
   operations    TABLE        CREATE TABLE public.operations (
    id integer NOT NULL,
    table_id integer NOT NULL,
    oper_type_id integer NOT NULL,
    edit_id integer NOT NULL,
    edit_value jsonb NOT NULL,
    edit_time timestamp without time zone DEFAULT now() NOT NULL,
    edit_user_id integer NOT NULL
);
    DROP TABLE public.operations;
       public         heap    postgres    false                       1259    18328    operations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.operations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.operations_id_seq;
       public          postgres    false    261            S           0    0    operations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.operations_id_seq OWNED BY public.operations.id;
          public          postgres    false    260            �            1259    18246    passengers_id_seq    SEQUENCE     �   CREATE SEQUENCE public.passengers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.passengers_id_seq;
       public          postgres    false    253            T           0    0    passengers_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.passengers_id_seq OWNED BY public.passengers.id;
          public          postgres    false    252            �            1259    18054    ranks_id_seq    SEQUENCE     �   CREATE SEQUENCE public.ranks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.ranks_id_seq;
       public          postgres    false    222            U           0    0    ranks_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.ranks_id_seq OWNED BY public.ranks.id;
          public          postgres    false    221            �            1259    18162    roles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    243            V           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    242            �            1259    18082    shifts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.shifts_id_seq;
       public          postgres    false    230            W           0    0    shifts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;
          public          postgres    false    229            �            1259    18110    station_lines    TABLE     e   CREATE TABLE public.station_lines (
    station_id integer NOT NULL,
    line_id integer NOT NULL
);
 !   DROP TABLE public.station_lines;
       public         heap    postgres    false            �            1259    18104    stations    TABLE     [   CREATE TABLE public.stations (
    id integer NOT NULL,
    name character varying(100)
);
    DROP TABLE public.stations;
       public         heap    postgres    false            
           1259    18852    station_with_line    VIEW     z  CREATE VIEW public.station_with_line AS
 SELECT s.id AS station_id,
    s.name AS station_name,
    string_agg((l.name)::text, ', '::text) AS line_name,
    min((l.color_hex)::text) AS color_hex
   FROM ((public.stations s
     JOIN public.station_lines sl ON ((sl.station_id = s.id)))
     JOIN public.lines l ON ((l.id = sl.line_id)))
  GROUP BY s.id, s.name
  ORDER BY s.id;
 $   DROP VIEW public.station_with_line;
       public          postgres    false    237    237    234    236    234    234    236            �            1259    18103    stations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.stations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.stations_id_seq;
       public          postgres    false    236            X           0    0    stations_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;
          public          postgres    false    235            �            1259    18061    statuses_id_seq    SEQUENCE     �   CREATE SEQUENCE public.statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public          postgres    false    224            Y           0    0    statuses_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;
          public          postgres    false    223                       1259    18312    tables    TABLE     a   CREATE TABLE public.tables (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
    DROP TABLE public.tables;
       public         heap    postgres    false            �            1259    18185    tokens    TABLE     �   CREATE TABLE public.tokens (
    id integer NOT NULL,
    create_time timestamp without time zone DEFAULT now() NOT NULL,
    date_end timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    token character varying(128) NOT NULL
);
    DROP TABLE public.tokens;
       public         heap    postgres    false            �            1259    18184    tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tokens_id_seq;
       public          postgres    false    246            Z           0    0    tokens_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;
          public          postgres    false    245            �            1259    18140    transfer_times    TABLE     �   CREATE TABLE public.transfer_times (
    st1_id integer NOT NULL,
    st2_id integer NOT NULL,
    "time" time without time zone NOT NULL
);
 "   DROP TABLE public.transfer_times;
       public         heap    postgres    false            �            1259    18125    travel_times    TABLE     �   CREATE TABLE public.travel_times (
    st1_id integer NOT NULL,
    st2_id integer NOT NULL,
    "time" time without time zone NOT NULL
);
     DROP TABLE public.travel_times;
       public         heap    postgres    false            �            1259    18155    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    241            [           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    240            �            1259    18235    working_days    TABLE     ~  CREATE TABLE public.working_days (
    id integer NOT NULL,
    employee_work_id integer NOT NULL,
    shift_date date NOT NULL,
    is_additional_day bit(1) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    is_other_work_time bit(1) NOT NULL,
    lunch_start time without time zone,
    lunch_end time without time zone
);
     DROP TABLE public.working_days;
       public         heap    postgres    false                       1259    18899    working_day_employees    VIEW     !  CREATE VIEW public.working_day_employees AS
 SELECT wd.id,
    wd.employee_work_id,
    e.is_male,
    (wd.shift_date + wd.start_time) AS start_time,
        CASE
            WHEN (wd.end_time < wd.start_time) THEN ((wd.shift_date + wd.end_time) + '1 day'::interval)
            ELSE (wd.shift_date + wd.end_time)
        END AS end_time,
    wd.lunch_start,
    wd.lunch_end
   FROM ((public.working_days wd
     JOIN public.employee_works ew ON ((ew.id = wd.employee_work_id)))
     JOIN public.employees e ON ((e.user_id = ew.employee_id)));
 (   DROP VIEW public.working_day_employees;
       public          postgres    false    247    247    249    249    251    251    251    251    251    251    251            �            1259    18234    working_days_id_seq    SEQUENCE     �   CREATE SEQUENCE public.working_days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.working_days_id_seq;
       public          postgres    false    251            \           0    0    working_days_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.working_days_id_seq OWNED BY public.working_days.id;
          public          postgres    false    250            .           2604    18883 	   _names id    DEFAULT     f   ALTER TABLE ONLY public._names ALTER COLUMN id SET DEFAULT nextval('public._names_id_seq'::regclass);
 8   ALTER TABLE public._names ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    269    269                       2604    18093    acceptance_methods id    DEFAULT     ~   ALTER TABLE ONLY public.acceptance_methods ALTER COLUMN id SET DEFAULT nextval('public.acceptance_methods_id_seq'::regclass);
 D   ALTER TABLE public.acceptance_methods ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    231    232    232                       2604    18079    areas id    DEFAULT     d   ALTER TABLE ONLY public.areas ALTER COLUMN id SET DEFAULT nextval('public.areas_id_seq'::regclass);
 7   ALTER TABLE public.areas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    228    227    228            (           2604    18264    bids id    DEFAULT     b   ALTER TABLE ONLY public.bids ALTER COLUMN id SET DEFAULT nextval('public.bids_id_seq'::regclass);
 6   ALTER TABLE public.bids ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    254    255    255                       2604    18072    categories id    DEFAULT     n   ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);
 <   ALTER TABLE public.categories ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225    226            %           2604    18211    employee_works id    DEFAULT     v   ALTER TABLE ONLY public.employee_works ALTER COLUMN id SET DEFAULT nextval('public.employee_works_id_seq'::regclass);
 @   ALTER TABLE public.employee_works ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    248    249    249                       2604    18100    lines id    DEFAULT     d   ALTER TABLE ONLY public.lines ALTER COLUMN id SET DEFAULT nextval('public.lines_id_seq'::regclass);
 7   ALTER TABLE public.lines ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    234    234            +           2604    18323    operation_types id    DEFAULT     x   ALTER TABLE ONLY public.operation_types ALTER COLUMN id SET DEFAULT nextval('public.operation_types_id_seq'::regclass);
 A   ALTER TABLE public.operation_types ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258    259            ,           2604    18332    operations id    DEFAULT     n   ALTER TABLE ONLY public.operations ALTER COLUMN id SET DEFAULT nextval('public.operations_id_seq'::regclass);
 <   ALTER TABLE public.operations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    261    261            '           2604    18250    passengers id    DEFAULT     n   ALTER TABLE ONLY public.passengers ALTER COLUMN id SET DEFAULT nextval('public.passengers_id_seq'::regclass);
 <   ALTER TABLE public.passengers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    252    253    253                       2604    18058    ranks id    DEFAULT     d   ALTER TABLE ONLY public.ranks ALTER COLUMN id SET DEFAULT nextval('public.ranks_id_seq'::regclass);
 7   ALTER TABLE public.ranks ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    222    222            "           2604    18166    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    242    243    243                       2604    18086 	   shifts id    DEFAULT     f   ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);
 8   ALTER TABLE public.shifts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    230    230                        2604    18107    stations id    DEFAULT     j   ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);
 :   ALTER TABLE public.stations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    236    236                       2604    18065    statuses id    DEFAULT     j   ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);
 :   ALTER TABLE public.statuses ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223    224            #           2604    18188 	   tokens id    DEFAULT     f   ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);
 8   ALTER TABLE public.tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    246    245    246            !           2604    18159    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    240    241    241            &           2604    18238    working_days id    DEFAULT     r   ALTER TABLE ONLY public.working_days ALTER COLUMN id SET DEFAULT nextval('public.working_days_id_seq'::regclass);
 >   ALTER TABLE public.working_days ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    251    250    251            D          0    18890    _bid_trz 
   TABLE DATA           .   COPY public._bid_trz (id, "time") FROM stdin;
    public          postgres    false    270   �d      C          0    18880    _names 
   TABLE DATA           Q   COPY public._names (id, last_name, first_name, middle_name, is_male) FROM stdin;
    public          postgres    false    269   �n      $          0    18090    acceptance_methods 
   TABLE DATA           6   COPY public.acceptance_methods (id, name) FROM stdin;
    public          postgres    false    232   �                 0    18076    areas 
   TABLE DATA           )   COPY public.areas (id, name) FROM stdin;
    public          postgres    false    228   ?�      ;          0    18261    bids 
   TABLE DATA           A  COPY public.bids (id, pas_id, count_pass, category_id, baggage_type, baggage_weight, is_need_help, st_beg_id, st_beg_desc, st_end_id, st_end_desc, start_time, meeting_time, completion_time, status_id, number_all, number_sex_m, number_sex_f, execution_time, acceptance_method_id, create_time, additional_info) FROM stdin;
    public          postgres    false    255   ��                0    18069 
   categories 
   TABLE DATA           A   COPY public.categories (id, code, name, description) FROM stdin;
    public          postgres    false    226   x�      <          0    18297    employee_on_bids 
   TABLE DATA           ^   COPY public.employee_on_bids (bid_id, employee_work_id, is_automatic, is_deleted) FROM stdin;
    public          postgres    false    256   ��      5          0    18208    employee_works 
   TABLE DATA           �   COPY public.employee_works (id, employee_id, rank_id, shift_id, area_id, work_phone, start_time, end_time, only_light_work) FROM stdin;
    public          postgres    false    249   Ӻ      3          0    18197 	   employees 
   TABLE DATA           U   COPY public.employees (user_id, personnel_number, is_male, person_phone) FROM stdin;
    public          postgres    false    247   3�      &          0    18097    lines 
   TABLE DATA           4   COPY public.lines (id, name, color_hex) FROM stdin;
    public          postgres    false    234   7�      ?          0    18320    operation_types 
   TABLE DATA           3   COPY public.operation_types (id, name) FROM stdin;
    public          postgres    false    259    �      A          0    18329 
   operations 
   TABLE DATA           n   COPY public.operations (id, table_id, oper_type_id, edit_id, edit_value, edit_time, edit_user_id) FROM stdin;
    public          postgres    false    261   R�      9          0    18247 
   passengers 
   TABLE DATA           �   COPY public.passengers (id, last_name, first_name, middle_name, is_male, category_id, is_eks, phone_info, add_info) FROM stdin;
    public          postgres    false    253   ��                0    18055    ranks 
   TABLE DATA           )   COPY public.ranks (id, name) FROM stdin;
    public          postgres    false    222   d�      /          0    18163    roles 
   TABLE DATA           )   COPY public.roles (id, name) FROM stdin;
    public          postgres    false    243   ��      "          0    18083    shifts 
   TABLE DATA           *   COPY public.shifts (id, name) FROM stdin;
    public          postgres    false    230   (�      )          0    18110    station_lines 
   TABLE DATA           <   COPY public.station_lines (station_id, line_id) FROM stdin;
    public          postgres    false    237   ^�      (          0    18104    stations 
   TABLE DATA           ,   COPY public.stations (id, name) FROM stdin;
    public          postgres    false    236   ��                0    18062    statuses 
   TABLE DATA           ,   COPY public.statuses (id, name) FROM stdin;
    public          postgres    false    224   �      =          0    18312    tables 
   TABLE DATA           *   COPY public.tables (id, name) FROM stdin;
    public          postgres    false    257   �      2          0    18185    tokens 
   TABLE DATA           K   COPY public.tokens (id, create_time, date_end, user_id, token) FROM stdin;
    public          postgres    false    246   �      +          0    18140    transfer_times 
   TABLE DATA           @   COPY public.transfer_times (st1_id, st2_id, "time") FROM stdin;
    public          postgres    false    239   �      *          0    18125    travel_times 
   TABLE DATA           >   COPY public.travel_times (st1_id, st2_id, "time") FROM stdin;
    public          postgres    false    238   8      0          0    18169 
   user_roles 
   TABLE DATA           6   COPY public.user_roles (user_id, role_id) FROM stdin;
    public          postgres    false    244   �      -          0    18156    users 
   TABLE DATA           X   COPY public.users (id, login, password, last_name, first_name, middle_name) FROM stdin;
    public          postgres    false    241   �      7          0    18235    working_days 
   TABLE DATA           �   COPY public.working_days (id, employee_work_id, shift_date, is_additional_day, start_time, end_time, is_other_work_time, lunch_start, lunch_end) FROM stdin;
    public          postgres    false    251   �      ]           0    0    _names_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public._names_id_seq', 800, true);
          public          postgres    false    268            ^           0    0    acceptance_methods_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.acceptance_methods_id_seq', 2, true);
          public          postgres    false    231            _           0    0    areas_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.areas_id_seq', 8, true);
          public          postgres    false    227            `           0    0    bids_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.bids_id_seq', 489498, true);
          public          postgres    false    254            a           0    0    categories_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.categories_id_seq', 12, true);
          public          postgres    false    225            b           0    0    employee_works_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.employee_works_id_seq', 1258, true);
          public          postgres    false    248            c           0    0    lines_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.lines_id_seq', 22, true);
          public          postgres    false    233            d           0    0    operation_types_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.operation_types_id_seq', 3, true);
          public          postgres    false    258            e           0    0    operations_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.operations_id_seq', 24, true);
          public          postgres    false    260            f           0    0    passengers_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.passengers_id_seq', 47473, true);
          public          postgres    false    252            g           0    0    ranks_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.ranks_id_seq', 3, true);
          public          postgres    false    221            h           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 12, true);
          public          postgres    false    242            i           0    0    shifts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shifts_id_seq', 5, true);
          public          postgres    false    229            j           0    0    stations_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.stations_id_seq', 452, true);
          public          postgres    false    235            k           0    0    statuses_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.statuses_id_seq', 13, true);
          public          postgres    false    223            l           0    0    tokens_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);
          public          postgres    false    245            m           0    0    users_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.users_id_seq', 1259, true);
          public          postgres    false    240            n           0    0    working_days_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.working_days_id_seq', 396, true);
          public          postgres    false    250            f           2606    18885    _names _names_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public._names
    ADD CONSTRAINT _names_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public._names DROP CONSTRAINT _names_pkey;
       public            postgres    false    269            :           2606    18095 -   acceptance_methods pk__acceptance_methods__id 
   CONSTRAINT     k   ALTER TABLE ONLY public.acceptance_methods
    ADD CONSTRAINT pk__acceptance_methods__id PRIMARY KEY (id);
 W   ALTER TABLE ONLY public.acceptance_methods DROP CONSTRAINT pk__acceptance_methods__id;
       public            postgres    false    232            6           2606    18081    areas pk__areas__id 
   CONSTRAINT     Q   ALTER TABLE ONLY public.areas
    ADD CONSTRAINT pk__areas__id PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.areas DROP CONSTRAINT pk__areas__id;
       public            postgres    false    228            X           2606    18266    bids pk__bids__id 
   CONSTRAINT     O   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT pk__bids__id PRIMARY KEY (id);
 ;   ALTER TABLE ONLY public.bids DROP CONSTRAINT pk__bids__id;
       public            postgres    false    255            4           2606    18074    categories pk__categories__id 
   CONSTRAINT     [   ALTER TABLE ONLY public.categories
    ADD CONSTRAINT pk__categories__id PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.categories DROP CONSTRAINT pk__categories__id;
       public            postgres    false    226            Z           2606    18301 :   employee_on_bids pk__employee_on_bids__bid_id__employee_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.employee_on_bids
    ADD CONSTRAINT pk__employee_on_bids__bid_id__employee_id PRIMARY KEY (bid_id, employee_work_id);
 d   ALTER TABLE ONLY public.employee_on_bids DROP CONSTRAINT pk__employee_on_bids__bid_id__employee_id;
       public            postgres    false    256    256            R           2606    18213 %   employee_works pk__employee_works__id 
   CONSTRAINT     c   ALTER TABLE ONLY public.employee_works
    ADD CONSTRAINT pk__employee_works__id PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.employee_works DROP CONSTRAINT pk__employee_works__id;
       public            postgres    false    249            P           2606    18201     employees pk__employees__user_id 
   CONSTRAINT     c   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT pk__employees__user_id PRIMARY KEY (user_id);
 J   ALTER TABLE ONLY public.employees DROP CONSTRAINT pk__employees__user_id;
       public            postgres    false    247            <           2606    18102    lines pk__lines__id 
   CONSTRAINT     Q   ALTER TABLE ONLY public.lines
    ADD CONSTRAINT pk__lines__id PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.lines DROP CONSTRAINT pk__lines__id;
       public            postgres    false    234            `           2606    18325 '   operation_types pk__operation_types__id 
   CONSTRAINT     e   ALTER TABLE ONLY public.operation_types
    ADD CONSTRAINT pk__operation_types__id PRIMARY KEY (id);
 Q   ALTER TABLE ONLY public.operation_types DROP CONSTRAINT pk__operation_types__id;
       public            postgres    false    259            d           2606    18337    operations pk__operations__id 
   CONSTRAINT     [   ALTER TABLE ONLY public.operations
    ADD CONSTRAINT pk__operations__id PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.operations DROP CONSTRAINT pk__operations__id;
       public            postgres    false    261            V           2606    18254    passengers pk__passengers__id 
   CONSTRAINT     [   ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT pk__passengers__id PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.passengers DROP CONSTRAINT pk__passengers__id;
       public            postgres    false    253            0           2606    18060    ranks pk__ranks__id 
   CONSTRAINT     Q   ALTER TABLE ONLY public.ranks
    ADD CONSTRAINT pk__ranks__id PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.ranks DROP CONSTRAINT pk__ranks__id;
       public            postgres    false    222            H           2606    18168    roles pk__roles__id 
   CONSTRAINT     Q   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT pk__roles__id PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.roles DROP CONSTRAINT pk__roles__id;
       public            postgres    false    243            8           2606    18088    shifts pk__shifts__id 
   CONSTRAINT     S   ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT pk__shifts__id PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.shifts DROP CONSTRAINT pk__shifts__id;
       public            postgres    false    230            @           2606    18114 4   station_lines pk__station_lines__station_id__line_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.station_lines
    ADD CONSTRAINT pk__station_lines__station_id__line_id PRIMARY KEY (station_id, line_id);
 ^   ALTER TABLE ONLY public.station_lines DROP CONSTRAINT pk__station_lines__station_id__line_id;
       public            postgres    false    237    237            >           2606    18109    stations pk__stations__id 
   CONSTRAINT     W   ALTER TABLE ONLY public.stations
    ADD CONSTRAINT pk__stations__id PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.stations DROP CONSTRAINT pk__stations__id;
       public            postgres    false    236            2           2606    18067    statuses pk__statuses__id 
   CONSTRAINT     W   ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT pk__statuses__id PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.statuses DROP CONSTRAINT pk__statuses__id;
       public            postgres    false    224            \           2606    18316    tables pk__tables__id 
   CONSTRAINT     S   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT pk__tables__id PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.tables DROP CONSTRAINT pk__tables__id;
       public            postgres    false    257            N           2606    18191    tokens pk__tokens__id 
   CONSTRAINT     S   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT pk__tokens__id PRIMARY KEY (id);
 ?   ALTER TABLE ONLY public.tokens DROP CONSTRAINT pk__tokens__id;
       public            postgres    false    246            D           2606    18144 +   transfer_times pk__transfer__st1_id__st2_id 
   CONSTRAINT     u   ALTER TABLE ONLY public.transfer_times
    ADD CONSTRAINT pk__transfer__st1_id__st2_id PRIMARY KEY (st1_id, st2_id);
 U   ALTER TABLE ONLY public.transfer_times DROP CONSTRAINT pk__transfer__st1_id__st2_id;
       public            postgres    false    239    239            B           2606    18129 '   travel_times pk__travel__st1_id__st2_id 
   CONSTRAINT     q   ALTER TABLE ONLY public.travel_times
    ADD CONSTRAINT pk__travel__st1_id__st2_id PRIMARY KEY (st1_id, st2_id);
 Q   ALTER TABLE ONLY public.travel_times DROP CONSTRAINT pk__travel__st1_id__st2_id;
       public            postgres    false    238    238            L           2606    18173 +   user_roles pk__user_roles__user_id__role_id 
   CONSTRAINT     w   ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT pk__user_roles__user_id__role_id PRIMARY KEY (user_id, role_id);
 U   ALTER TABLE ONLY public.user_roles DROP CONSTRAINT pk__user_roles__user_id__role_id;
       public            postgres    false    244    244            F           2606    18161    users pk__users__id 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk__users__id PRIMARY KEY (id);
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT pk__users__id;
       public            postgres    false    241            T           2606    18240 !   working_days pk__working_days__id 
   CONSTRAINT     _   ALTER TABLE ONLY public.working_days
    ADD CONSTRAINT pk__working_days__id PRIMARY KEY (id);
 K   ALTER TABLE ONLY public.working_days DROP CONSTRAINT pk__working_days__id;
       public            postgres    false    251            b           2606    18327 )   operation_types uq__operation_types__name 
   CONSTRAINT     d   ALTER TABLE ONLY public.operation_types
    ADD CONSTRAINT uq__operation_types__name UNIQUE (name);
 S   ALTER TABLE ONLY public.operation_types DROP CONSTRAINT uq__operation_types__name;
       public            postgres    false    259            ^           2606    18318    tables uq__operations__name 
   CONSTRAINT     V   ALTER TABLE ONLY public.tables
    ADD CONSTRAINT uq__operations__name UNIQUE (name);
 E   ALTER TABLE ONLY public.tables DROP CONSTRAINT uq__operations__name;
       public            postgres    false    257            J           2606    18386    roles uq__roles__name 
   CONSTRAINT     P   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT uq__roles__name UNIQUE (name);
 ?   ALTER TABLE ONLY public.roles DROP CONSTRAINT uq__roles__name;
       public            postgres    false    243            w           2606    18292 ;   bids fk__bids__acceptance_methods__acceptance_method_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__acceptance_methods__acceptance_method_id__id FOREIGN KEY (acceptance_method_id) REFERENCES public.acceptance_methods(id);
 e   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__acceptance_methods__acceptance_method_id__id;
       public          postgres    false    3386    232    255            x           2606    18272 -   bids fk__bids__categories__create_user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__categories__create_user_id__id FOREIGN KEY (category_id) REFERENCES public.categories(id);
 W   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__categories__create_user_id__id;
       public          postgres    false    226    255    3380            y           2606    18267 %   bids fk__bids__passengers__pas_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__passengers__pas_id__id FOREIGN KEY (pas_id) REFERENCES public.passengers(id);
 O   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__passengers__pas_id__id;
       public          postgres    false    253    3414    255            z           2606    18277 &   bids fk__bids__stations__st_beg_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__stations__st_beg_id__id FOREIGN KEY (st_beg_id) REFERENCES public.stations(id);
 P   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__stations__st_beg_id__id;
       public          postgres    false    3390    236    255            {           2606    18282 &   bids fk__bids__stations__st_end_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__stations__st_end_id__id FOREIGN KEY (st_end_id) REFERENCES public.stations(id);
 P   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__stations__st_end_id__id;
       public          postgres    false    236    255    3390            |           2606    18287 &   bids fk__bids__statuses__status_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.bids
    ADD CONSTRAINT fk__bids__statuses__status_id__id FOREIGN KEY (status_id) REFERENCES public.statuses(id);
 P   ALTER TABLE ONLY public.bids DROP CONSTRAINT fk__bids__statuses__status_id__id;
       public          postgres    false    255    3378    224            }           2606    18302 7   employee_on_bids fk__employee_on_bids__bids__bid_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_on_bids
    ADD CONSTRAINT fk__employee_on_bids__bids__bid_id__id FOREIGN KEY (bid_id) REFERENCES public.bids(id);
 a   ALTER TABLE ONLY public.employee_on_bids DROP CONSTRAINT fk__employee_on_bids__bids__bid_id__id;
       public          postgres    false    3416    256    255            ~           2606    18307 K   employee_on_bids fk__employee_on_bids__employee_works__employee_work_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_on_bids
    ADD CONSTRAINT fk__employee_on_bids__employee_works__employee_work_id__id FOREIGN KEY (employee_work_id) REFERENCES public.employee_works(id);
 u   ALTER TABLE ONLY public.employee_on_bids DROP CONSTRAINT fk__employee_on_bids__employee_works__employee_work_id__id;
       public          postgres    false    249    3410    256            q           2606    18229 :   employee_works fk__employee_works__areas__area_id__user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_works
    ADD CONSTRAINT fk__employee_works__areas__area_id__user_id FOREIGN KEY (area_id) REFERENCES public.areas(id);
 d   ALTER TABLE ONLY public.employee_works DROP CONSTRAINT fk__employee_works__areas__area_id__user_id;
       public          postgres    false    249    228    3382            r           2606    18214 B   employee_works fk__employee_works__employees__employee_id__user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_works
    ADD CONSTRAINT fk__employee_works__employees__employee_id__user_id FOREIGN KEY (employee_id) REFERENCES public.employees(user_id);
 l   ALTER TABLE ONLY public.employee_works DROP CONSTRAINT fk__employee_works__employees__employee_id__user_id;
       public          postgres    false    249    247    3408            s           2606    18219 5   employee_works fk__employee_works__ranks__rank_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_works
    ADD CONSTRAINT fk__employee_works__ranks__rank_id__id FOREIGN KEY (rank_id) REFERENCES public.ranks(id);
 _   ALTER TABLE ONLY public.employee_works DROP CONSTRAINT fk__employee_works__ranks__rank_id__id;
       public          postgres    false    249    222    3376            t           2606    18224 <   employee_works fk__employee_works__shifts__shift_id__user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_works
    ADD CONSTRAINT fk__employee_works__shifts__shift_id__user_id FOREIGN KEY (shift_id) REFERENCES public.shifts(id);
 f   ALTER TABLE ONLY public.employee_works DROP CONSTRAINT fk__employee_works__shifts__shift_id__user_id;
       public          postgres    false    3384    249    230            v           2606    18255 8   passengers fk__employees__categories__create_user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT fk__employees__categories__create_user_id__id FOREIGN KEY (category_id) REFERENCES public.categories(id);
 b   ALTER TABLE ONLY public.passengers DROP CONSTRAINT fk__employees__categories__create_user_id__id;
       public          postgres    false    226    253    3380            p           2606    18202 +   employees fk__employees__users__user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk__employees__users__user_id__id FOREIGN KEY (user_id) REFERENCES public.users(id);
 U   ALTER TABLE ONLY public.employees DROP CONSTRAINT fk__employees__users__user_id__id;
       public          postgres    false    241    3398    247                       2606    18343 <   operations fk__operations__operation_types__oper_type_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.operations
    ADD CONSTRAINT fk__operations__operation_types__oper_type_id__id FOREIGN KEY (oper_type_id) REFERENCES public.operation_types(id);
 f   ALTER TABLE ONLY public.operations DROP CONSTRAINT fk__operations__operation_types__oper_type_id__id;
       public          postgres    false    261    259    3424            �           2606    18338 .   operations fk__operations__tabls__table_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.operations
    ADD CONSTRAINT fk__operations__tabls__table_id__id FOREIGN KEY (table_id) REFERENCES public.tables(id);
 X   ALTER TABLE ONLY public.operations DROP CONSTRAINT fk__operations__tabls__table_id__id;
       public          postgres    false    3420    257    261            �           2606    18348 2   operations fk__operations__users__edit_user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.operations
    ADD CONSTRAINT fk__operations__users__edit_user_id__id FOREIGN KEY (edit_user_id) REFERENCES public.users(id);
 \   ALTER TABLE ONLY public.operations DROP CONSTRAINT fk__operations__users__edit_user_id__id;
       public          postgres    false    261    241    3398            g           2606    18120 3   station_lines fk__station_lines__lines__line_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.station_lines
    ADD CONSTRAINT fk__station_lines__lines__line_id__id FOREIGN KEY (line_id) REFERENCES public.lines(id);
 ]   ALTER TABLE ONLY public.station_lines DROP CONSTRAINT fk__station_lines__lines__line_id__id;
       public          postgres    false    3388    237    234            h           2606    18115 9   station_lines fk__station_lines__stations__station_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.station_lines
    ADD CONSTRAINT fk__station_lines__stations__station_id__id FOREIGN KEY (station_id) REFERENCES public.stations(id);
 c   ALTER TABLE ONLY public.station_lines DROP CONSTRAINT fk__station_lines__stations__station_id__id;
       public          postgres    false    236    3390    237            o           2606    18192 %   tokens fk__tokens__users__user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT fk__tokens__users__user_id__id FOREIGN KEY (user_id) REFERENCES public.roles(id);
 O   ALTER TABLE ONLY public.tokens DROP CONSTRAINT fk__tokens__users__user_id__id;
       public          postgres    false    243    246    3400            k           2606    18145 2   transfer_times fk__transfer__stantions__st1_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfer_times
    ADD CONSTRAINT fk__transfer__stantions__st1_id__id FOREIGN KEY (st1_id) REFERENCES public.stations(id);
 \   ALTER TABLE ONLY public.transfer_times DROP CONSTRAINT fk__transfer__stantions__st1_id__id;
       public          postgres    false    236    239    3390            l           2606    18150 2   transfer_times fk__transfer__stantions__st2_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.transfer_times
    ADD CONSTRAINT fk__transfer__stantions__st2_id__id FOREIGN KEY (st2_id) REFERENCES public.stations(id);
 \   ALTER TABLE ONLY public.transfer_times DROP CONSTRAINT fk__transfer__stantions__st2_id__id;
       public          postgres    false    236    239    3390            i           2606    18130 .   travel_times fk__travel__stantions__st1_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.travel_times
    ADD CONSTRAINT fk__travel__stantions__st1_id__id FOREIGN KEY (st1_id) REFERENCES public.stations(id);
 X   ALTER TABLE ONLY public.travel_times DROP CONSTRAINT fk__travel__stantions__st1_id__id;
       public          postgres    false    238    236    3390            j           2606    18135 .   travel_times fk__travel__stantions__st2_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.travel_times
    ADD CONSTRAINT fk__travel__stantions__st2_id__id FOREIGN KEY (st2_id) REFERENCES public.stations(id);
 X   ALTER TABLE ONLY public.travel_times DROP CONSTRAINT fk__travel__stantions__st2_id__id;
       public          postgres    false    236    238    3390            m           2606    18179 -   user_roles fk__user_roles__roles__role_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk__user_roles__roles__role_id__id FOREIGN KEY (role_id) REFERENCES public.roles(id);
 W   ALTER TABLE ONLY public.user_roles DROP CONSTRAINT fk__user_roles__roles__role_id__id;
       public          postgres    false    243    3400    244            n           2606    18174 -   user_roles fk__user_roles__users__user_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk__user_roles__users__user_id__id FOREIGN KEY (user_id) REFERENCES public.users(id);
 W   ALTER TABLE ONLY public.user_roles DROP CONSTRAINT fk__user_roles__users__user_id__id;
       public          postgres    false    241    244    3398            u           2606    18241 C   working_days fk__working_days__employee_works__employee_work_id__id    FK CONSTRAINT     �   ALTER TABLE ONLY public.working_days
    ADD CONSTRAINT fk__working_days__employee_works__employee_work_id__id FOREIGN KEY (employee_work_id) REFERENCES public.employee_works(id);
 m   ALTER TABLE ONLY public.working_days DROP CONSTRAINT fk__working_days__employee_works__employee_work_id__id;
       public          postgres    false    249    3410    251            D   3
  x�u�]��	��3��|)QP8k�������T��<��'}x�!���:���?$��X?<~��j��>]i_�������C����O�=퇵�����}���2@}|(��m����G\���|�
ԅ���6���H?䒌@F��F�y|Z���	��BB62�-�C���qn���Z�͗�gp��F�6�r"r��g�5���[�-엢�Z�"j��T���4�u�m�%zHHc�>�@��&��/���!K��h�ל�^�Q.�K�C�iv�5c�k-#�BĹj�(���D��|c�l�V���s���Ek#��^G(����5xǗzT�?���~_[/>��X��3z"B�����$=j�bc�%��PQۈ�UD��Z�YDV�����Å���_ʾ�I�}Z��ވ�.����g�ϲ�Q�-?#�+�H/��?��y�S'�U�Z�#�2R֢����Vg@�W�����7���$�oĹ!+ w촡�ez���l:��Je]��*��2'D�|^O?�p��DѨ�nK2�:RD�$��wVo�m}��h���o3W�Ȣ 2%bD~�6��Ñ�F���3c��em�QS<�����[he9D��
/M1� yTn����3�.�PBG;����v"����fUj�m8t�q��E�"��m(Z�BYS�5H��yޛ \5f]
�^9*����Q�W?�^!zV�%F�%{'=���*��0�H$�$������sCn�\��Hy��K�r�E�����H� z8.��;�:@Ѩl��#�څ��PG($���<Ԫ��st!����):�u��L�mgr�})=W����c
 �����z�/z�m(r�D�.C�Aa�}�L�H2�+�^Ѱ�U2�7�	֑�m�F��v��v��� �^�Q�m��Q�!$���\:�Qf���ܰ/D��R@/�pHˋ���\�v�xݴJ˲P��H��&b@�5���_O>3DV��m��R2G���ң��@�C�LD�6o�:���!a�<�M�
ˑH7�~!��(�f�@4����T���o����F/�N�썲ͣ�I䎝�u6��<U���]zE��-��B^����7�M���w_y)g�Wh<{����*�.oD�
���	v��ȃ�V�z��Lk�]J�K)�0"�we<Y���E#=хƞTP�	(b9�Z
�?>��!�遷��29,eD��W�-a�R$� ��̣��1��/{�����D��[Vp���;���kCn�Hp����FY�t��n�R�9��(��F�m`��~�Y�^R�7��6��u�Eφ(ް��7��%벷�o4,�����M?Tc@��L풰�D�i��ꅨ�.����Uu0�7�L������k���'�'�ڝ�b�BՋڐ7��kw��+o\������,k����mD�zfD�& /m%�t@}�y#����}=�G�9E�����u���zV�ٙ'�jE�1��^k!��˶�||���D��^ӗO{`��^%�7O`Fo$��1gKk�<�*�D$9=�F�����l!�!*	���H��<�k���y퍶����`�q�q�F1�O��ސ�:pJx�C��p�5sՊ�t4QvD����P�CՑ�QI(Q	���PP�gVi���'+{ G�f��H uy���|�������^G�H?���j�,��#z��p�ʃ���U�'LmȈb�Dh��3}9Bk�������{Z#6�PT96�RQ��z�\ݗ����ܗ�T��Q�P�x��*��U�8B����#t �NϚ�5X��`h�� )��5�I���3��!�D��5�CFI��p�GUF%�Y@�%ᬀ���P+̯��2�Q�%ܯ��yj�2GQ3@{L�5D�J �Q�2QGT_�D\�'bD5�q�z�7B"�+��B�29T��i�k��VɁ:n�<|ᆽ�.9��Zb��6�8BC�|6h������0;sG��F�2����[冠 FUE�� �~���f��H��P9>d�@A����U�v.%T9�Tޗ��]��Q}Dv����yAkķ�:�1����|�ZC��5�j�Y*GTs�~O1�j����� E;�zA��(�2A���Js�4/D�ô
�|'��PB~j%)J�&7TCV�s5%fb�cC�����p��J�bD�2[o�Yk�D�hV��P6ڳ/�P6�ڐ=�W��"*�=�P�����/ݿX(��~�2D�5e�2Ԕ=sH��PS6*�ϒ�X�xV�+S�~����B�������gCCTCB�����m�p�B��1No9�rd�����/����;���Pw"ڟ��� I}׳�Y��6��ҫ�=
�D�<M{��ެ	�#4�~x�@�лsT�ŷ���Q�����R��Q��r��n�c��rJxv��S���嚥�g����b���ƙ76�����[�a^���ی3�x���Ơ�H+����VJ�h<n3�B�s.jc0 ��ن�(~�WAt}���K�p�8�_\��l��}���#�Oi�}E;dU�}_9N���m�~)6&Q�7d�-�g�y)�ϙ�T��� �����?�����/M���      C      x��]ٖE�}�����G��<��P�i�CO#j8H�f�� URAI��~!�&̷��zd����-׮�{���?�_ߞ>8�=^���ӟ�����;>]����p|u���_��_���9}H����Wq��������?���9�>]�����#��~�ͫ�{o��N�7��O��gyDItz��d��w���C'���ٗ�{�/�h�:���_ġ=g_�v�r�\{{z�>��&�w������U�������h)�ض4��b>�{ǯ�?������'�B���o����#�?���ӯ�%�#�����u�q�/hH������*�~����we������>�zݏi�h2/�&�=���������TO��Y���W�y�~�&�k]-���?���_�ɾ���7듯��^gFkUWv;����)b^S���W�ױ���Y��/���EbOt�y=�W�~@��F�U��e���_���f��dh\"șׅ���!�Ǫb�W��[��ley��f��XC��9ê�g5��[����K�kê�f����0.T^��l�Lf �>ߑH��9���aL��9_�_�WxQ�Y��֪�y(?�-�t�&��K.����v�l�u�@7|^H#�<b�����z���!`�HD�m��0'�� z��7 +���'�rϵJ.�!�d6���;i7����*�Y�06�^��>(���R^��/֏�c�T��_��٦�O���'��K�`5)�.t����n�ߺ٬T��ק�b���ϻ�����I�(�!�|?��_U�Ǩ=�Q���|���ƅ&wu??��46Ǎ=��iP��Mܷ�R蓶���G0n��lӫ���@�Y�_#���3�Jg�Yݛ&��7����p��A��pS�?/Io7��M���Ї��X�z.���I�
�z�t�ԏXܕ>Db�,5�}>�:K�o0��}��M�x�a]�,���i��Q㮲"�2�(����>������<r�\ԔED���w?g-br#� f`o�&zY/�k�k?���R�p� |}��8�k��X�~����Z��Yۆܜ��N���ͱݺ���ί�lɝy�OI�W[~ǿߧ��~�w����|�Ѓs���'�7>DkA^����Dl~Lx�:��s
�r���)��{�\y~�f���y-eC+FJ@��O�W��Z|+���<Y��s�ohO^��s��1-�f�>bߗ<62��p{Nʎ�X�N�x����eHH���*�p�!�ꡍ�B�f�V���I?�	Q?�.�^���2Č莯�@0�⸮s��86L )3,��!8���F�v-�@�	�ܭ��������އ���Z�=:X���~���:�3?�˂�m3,d�7��x�>듶��;����v��x���}�*��� � ��,��W�Wt�5WIx5��,����'ϓ����l�{����aܔ����;�S;8{9���Tĸ7�j~�Qy�6��g0:����?����d�-�2"cKg,�Z�^�=>���!���]+YF��a��MQ٣�T��p�˶���}Q�����p�²j/�����j��e6	�-b֔���"�߲$Ov��]�:��}�%ն0E;�����i8�o0YW��]R�:.W���>!��}��OA��r��
�ͭ?h�K\8z
�,a��d;��\R�6{��Bߵ���ːM�D��砦Ҩ��$���d��'�5�$�c��'�����"���:ܞ�ۿ'�+w�XҎ��k���.@���������V��P �oiC~�,�nr�=���ĭ`�6C �^�N��D�~ׁQ�'5�o�/��T.�eVEa�C�tT�z�zbqWt���ɘ%ؾ���P?���<Bh#d1	��~@���
���aJ���<�	-��9�yQ��7=ѸU��d�&�=1��i������!�j̏�M��� �'����x-�����h�g�?�����#&^����w1B_EL	!y3g��Md�� ��Ȑ~�?��A��Xh��AZ�;�M�"�V��:���$1����d	j;���զ����Y^�P1n)����jة~���P��_��s*��e3�4@=;@��L6��)y�j1���t�iSZ�ߡ��R�]��W'��}�ݱ�N؃^�S)>R�O�y�/������Ct���� �Q�*�ϑ ���.��M�|�]t0C���$p��{bziV7���P Tq"y�Z���R�$���x�r�!�eO�.�v����k��U�,g����*� [����"��c�o
�����M���^�]�{�hԖ�����c39;��]�׹�.D�W�{"jS9o+)iG�h�޻�`�t��PP�Z���` .������y�����������L��<�Ku���D��֖E�l����ކ�vL��eJ>j]��� ��i�G���V�}֡'��q,q�hx�ҟ� �����oJ��`i4������)$��$����R-�D��-iB��BG;w`K;�\|�xy\9r��\�9�@5�R{�z#z˫� ��p�������Z�v����u{ET�V�<���R7�ia���A<Wd{Ñ	����X_So^�b�̈�-�7������ė��q���^@�T��1+b|u��6X���P-�Å��x�/{ǫ���]�Ⳏ���W�l�&��������oz"�9�2��b{`���VB5t�a�L�A�l��ԕ@PKPņv܋C7(*���@o�����ص���/(�6���C75�Z��s0�`��ׁ8�g�_E�-xLt,�V�3�S�/����ˍ��?�Q�?���!��4V=��#|Y�b���G�Xt����^�wr',����Y��ms�	�ؔAr~�3[�H��Aq{譏b�~{d����ڶ�C��ʩ���~U���T`��Х	\1ޛ��F���&�l�J+BQg�3�ς�7����GC�!"�����������kA�@,1&e�ʄq��0�N���_�_��`Ca��ȱ�UM�C��5�5�P���P�_Dc���� 3�Y�q �ƙ|u �W�q���HRD����/�q@��Zn� x��;"�a^���7����_���2 ����*V:=D���NV՗n:u�	2��Րx`�/>��
�_���H~�)��'OS�$�x�)�֯y�t�a��U����܊�4�1�?VKE����47��i�ui�� �T1򇛢\�0gb��e�+�DM/G<�Oу�ʳ8�.��K�Z��w1�wNۈ�X����vR	ⅿ�kw���H�"��<�_O#��=u6�Z{�kX$�(�2t;p{�J�����S	7����g7�xc��1O��&��ԉ

~���j����Bٕ:QDʢz��
�S�h��;���l��N^К=� �<v��,0yY�#�#��Q~�+O7`��:��^�J�0��.�l8��}��� `�V4��Y�0��jl"�0Ab�����cU��T7�.�7��3��C�,��!�>s��ܒz^>���>s�Y{:�Ʊ��g\:����5��<��	%jb�1��������fcx ����L"�ʶv�.���h��(�kfo�����+�!f�6w����<��GUI�A1��4S��6���bӯTN��71���� ��|;�m�8�c�
+�!�1�Ї/"��'�[��	_){��eX`�Dp��o���|�y ���xb���a�X�ư������L�PB6�na;8xT�o�Ws<����-��{}.X��nL���w&���Ep2%�l�z�΁h���C�w���i��6�0vb|Q�8v�V�(�a�Id�Ffk!�	.c�;��+Rc�N�j��N�&\D�AlP,U6�k�PQ�l,=1��^��A�� H>��hl��Pf��̘z�oO��.��̱�͡ޜ����3�py\��Փ�|��N�(�r#��Fb~:}p�c,��=�"�� ��a�"3��p@��S���Z�q�%69�~?<� "�NIC�@=,A*Eӕ�"ϯ�"��o/`��l�%sx��f��&�n[�6>�O�W    ��j\�0�YiO������8�f���Ε�b�P��� G��!�F��"���D��']з1�y�����b�����qV�m�&q�z�
\�� p��h{) �`�g�@��-u$����~v��%���}��o�Fsk�a35?&�������2��DJ��)a�Sjt�*�`�8�hQ�o�\k�f}(�p��>nwB��t�������b�Z��h�֘�O�^dk�����Fsv�*`��bٞ ������v�Ì�?��*D�!@5���{�P���L@�7��[@��8ѣ�id�#���N�����#�,��?���;}�b+�ؼ�]�իL�0s��j���?̅����kTOl��}#����БxaU�ͺ�~�]�i`�x_��.�f�*1�t|�u�<݅�a��w�)C�VIK��oď��t3M�N�aw�\�Gß��#@+&걁Qc��3�
O�ϝA���a�'kto�%aIs}�mU7ukP1�9V��y�1�0�]SPw�7�)�6�k�yBq�D�y�쯻�qv�}_�ԇ�o��O���y�J�6s[�Q1|bx$.�_��7�:w���d�%ZE >1��`���^�0.�꙲̃v�ː�{�<��-n���J����pD���Z�r� �T�4{��@��c&�9�k��@aT�#~F�xp���УK������R�qF��ǁ�ٺ�dl-��:���{�@���"��X�ݺ��S9���t��d��^E�ގ&���EЃ�'��
�"�ḇYc*bs�#��q�>H�X�U�"���EĒa2_�:�y�XPD�v�I��O�1P�.?����]E�Sؖ���dH4QO]��
jc��݂��[	_�	o:?��>J	MFE�c��`����S��3݂���h�RS�06�%ۓn/�cll�Dx]�5�u]���Tx�z�`��ڦNC\����z�d ��[�)bVW��鼽���6�.zM䠚q��sf�U`�"8�U�I«��z{�tJcg�U'!��"�g��;��E���o�(1wSga��Qd���e��;�"��K�/K��+M.B^t�B�ز�3+���cM%#YD⵭Q �eVų�DY@l�N��S�XG�<�/���W��N���M�BU�����n�x�&C&��?����ꜻ�9�v�^i���5߲�E(�4A��</b3�S[�w���	�ݜq���Jְ�PoRp	�^���"�n��- P�-���Q
Q�*�Yq�Z��[D�����U��VS��  ��eњ��X��s�F��,|�����ˍ��Z�^߲�|93����lo�x��"6�]�~ľ��*/%i�"��QO��� ?Ip�X�����~���{���W#��Z[E�6:^��/�f��g4�W��D\iD�0 �®�ǉ��h�d�?j}+�?3M��!;�L" p��A�Љ�"@ڣ�&U���D���~P��x*���b^��;��C��5s���eV�5��2	�Q;���إ�|o"�V�Ș�6��Y�@R6�s��������q㜵�A%5�8�f{s�r����H�ka�M.�z��ź��`iFD��ɚDX���E�?*wTz�'G�؈˘��-���tS���Iy���ĸ
�N,��|��Sd�/��l����&��pCi>��]�g@�)w+	�"�����%�`�]eE{�7a�EFU:���ɦ�)s}�^�qE�Qt�7 "��T#��,[Ctt��Z%�\'��u�7��e�H	�j�+	�H����kv��A-J�O�=�+w/���ED��S���
:k��~ `Bp�ۺ>���i�,666�OW}�Ӎ�?]E`��)���]��i��z}V�L��z{#�I�����de���U]o�"c��t�����r��r��V=,8�ka�b���b
�|�8S��&r���wK����GZ�V�d=+]I� fTl!+�����H����ߖ��ƭsH��z%ĸ V�[ ��/4-?ѳ��hR����3�}�#U�.����/Uh[�llG��Iqp�x��VGB,�F ȍP��%�.�oK��r���{sY���7�øl��e�����\��~���|+�_7�T?�(7q���u �[j��Jg�~����i�ES�V�&���}2T��n���KӅnB�&{�F��f�=W\#vӢ�F	W� �.�$�t�� �)mz��M�M��n`�"/�+�:;���}�L��\�m	���cՆ�� �X�w�F3�n�i�+�.�%�ē�{8/�!gЧ�w������b. �^�OS�B�cUC5;����@����EdՋo����Z1��=:֖-�-:��ݍ̚��p��e�-�C:�g�Ls�T~d�`��R��(�l=���^��ƀ�`���� 9bI���XD�7{8;L��U��x����㆓��I	:�D�/(�bj�[�X���./�QY��9?��l�p��ͽ�PO66��>��ln1�nA��<�1O B�"o�,B����vCYq;�F�;[1ws��T�1Z��O��Zb��]�//ꌮ����"�y��F�t�l���[�_pV�p��4�w5��2�ƈ��g�m���n��T�0��/�e���٩����=d:(���n��m���Z�i�8���O�3�܏�:q͒e�Mp��]d��ę:�'V3���6�V/�/�&+�U2��C��Fq7�ɪ,v<1��bK�f�]�Gw�uħ��	\,LZ6��Ő�&1���ij��Y����b���l�'&�Q��8_ߏ(v���~2G�a��_�w�mND�зz�N�v��Hv��:�`�k0�{��[��{�'�Ҩ*+$=Ho#+(���/��A@?Ց�O���I�
�o���- ����So������2ׂ\�0�$-�Dn�t���r,�����5�E�=�W�g�iZ(j�W�[���ZVh!_::i��\�X��O�_�����/�p[���dJ��_D�љ�ʫ�]�|�^K��'�ޞKq�ÞXKگ���4�Ey�q�{��}l�N��%>��Jf�5悸D��cN� ��h+�X����|�����sg�	�ĳ�^[#��L~�;:�� Yl�]�>���ѝ9i]2�StX�z��3%���L��|~�YNřn7��J�~�0���[`��������O]�w۲��Ѣ�����H]]���v�G[5�#��� )v�x���e� �S<;{H�;[�n� b*MŰ�"��f��x$�թ�"������z�љ����<�gq�����'s˺N��|G�K�-�� �@i�:[��H�}|y:�C{���Ŕ�a�B�H�XK�b@u2tzޯ�z9!�!�R\�k���|��]D5���� �s�@�g�%S�w�I<��J���%�g`i�U�~i��X�/H�P�%�f�P� f��(��^#��o޲.���Y�wo�"�i�ld��\|�,�AW6;sR�yB��^�/jx��޺����Fl$�r���96�g�	=�/�T�P�� �O������O�#]jxc|^�f�ԅT���b9+\��Ʋ8������_���9_O̥�RV!C������u~Y�$����3��u��]nV��������ʵ1���U��-y�E��:@CP��3�)0�=	�x~����O�����ߩş�^���i�J�Z��,#�ŀd��+i�p��m��kC�g�|T���ц~0
����B�O�
��m�z�q���u95������Vr❨|p̵Z4�U���ѡ���/��Ws�hrG^�40
C
���aL;��5�[O��_����EtG����r��n|��4�u�����G �!���&톒0�{r!��I�Aw� A�È�z/84ƚ�<�Π\ذ"zJ7T�6�q*�ԌKk(���`l��T����љ�¶�0��W/�V(y���0"���:�#:!us�c���ѱ�]��@,i}o�N�t��tQ׃-��|�S��}E"����Q����^Lc.��y�.   ��a��&�^�?|)J��a���D@i�.W�t�P#��o�߻+O:{J/��n;�
:�����M���=5\g����b�&�19ӭ7�ޘ�`Cc��e��,D7#�XjW�A��<.q���&�B�V��C��z;zr���u�鸳�8E֌��S�Ş��7�d3	��Č�T����I��
MG	~���~�Ř�ޙ�� ���E�J�g���2Լv��� �(���C�et� ��jӈ�ċV5e����s�.���Ѐ���zYv��ќ�R
�9Y���%��W��^��{w��/U��qo-V'�7O�l5Q�1�B����S��ޔY��1���{�H�;����vT�=p��H�6���:?���[��a�p!�'U�u'f'��R���$ue� L�8J(05P��~�٠��!}�NB_-���l<���ZXzH��t�bNuE Ee�=v����&���fր�	�3Kӈ����U���˄(�q7G��M2�t�)w�b�;�V������������      $   (   x�3估����/l��ra߅�\F������9\1z\\\ ��          ;   x�3估��b]C.#È��0�2�24.���2�pL�̠��9�c�eaXp��qqq � �      ;      x��]��e�m���s_���0�'`$����(E߾")-�"�Z{�A��3���mIϤR멷���W��_?��/����_������_�������?~�r������_��������������\Hr�O!}���s㟯?����W����k??���7_�������J��?�Ky�K��K�opD���@��jB���T���?�K��*�K���:��6>��d|��X@��=�����s�DH���l��F��)2��XB��X����������_���m���sj
H���z���z�/J�`����wls����zܣ���_p�@�u�M0`�5�y\�K�U��!�
��K.y�Ҷ	���
�����7rLk O���S�/�xE���޷�clr�o:�Ǚ.�%�ye.�w�v<�۷���sgȽ�����ޑ]3�������Cƌ�}�"ʄh0�u����6Q�O�?�EN��q��m|�q�9nj�+Ԛ�]d���s�*�`$�q��7d��q���ѕ�zCti��V_KNy|�AG[����C��k�s����r.z��e�q�/b��D����c�>>��{M_���O9��R+n�32�� �9�`S9`�7?4G�{��P)e�|���������Y�&p�\\�����.�ā�L���u��`ț���8U\������\�2�2SHk�U� ��Z�.p����Ja��J"�GԈQ���xz�{����'<p���~�ŖݠRS����b����:����&�=��\���Gvi�l*����Fsg��x.����J ��%�m�tL.i��#V+��)��L9�O8����8p4�'dWZ�����>m�x0�pIc��o�83�tӉ{���8�M\G�AtK��}0�0M8n5p	1���8mt��;��Op�..e��Tc�BC�f2�%q4��M0��*�	LL�Q@�l�>tn6�<��o9:~`�������#G�yBƢX�|d|�U�4r�k�>W�ꜥ^B]��i�'��[��&���R|��6I��� ��EH����Lh�l��r����U}q���Њ��+���W~����S�����<�2f�G�Zl=^�1?�%�.��ԈƼXp2p'����RŠ�&�q;w".�V���q��1r����ܷ�z0����;nb�qC�V-�<[L���p�&V��`����P/����pW)��P���]Y�a�L���q<8���A����2)����SGM��w��5� �5TB�w89��󐇤�:������Uڵ����`�e>�y�'\Z��ZS14������f᎓��`��[�L3�K�����n�"[G��3 {ǐ���b	�,���LhQ̮=]&�m���sNҒoH6%���=�iܬ=o1���dҲ��=cC�A���������� 6��v�rӖ�|=�}��;�`��˸�!�CV�v�Um1Z{�m�2�0�h������2)���R7C��">N�|��]-RJ'
؞�%Nx\ʸ	�����(��Z*�ʄ8.�!�����A�o����z����5��R�\��
�o Cxm�X� ]̀���z�l��r��A��1ny�V,`BL���L�D�;p����\$�l�ݧ��<�-����`Nb���0�7�bL�:�Y�>�����\���\� 9���>p�f ��ʾ�N�G�9oko|���bB��Z)����7�����RAhl\�	��,�� ���Zpp�{�0Nm�zQ�ly�iXә�R��.������sR1����<d�Ep��#��O>�nݶa�)���uܥ� 5�Pl��968:!E��	�@9|�NW9l�^��C���0|�8t��	s~lz`��A�O�A>��6�g"Bt����8lh�t"�i�3G��:i�	'k���3�H�Qlw��ol�P�~��ck��JU+-B�2�扁���	9� �#a�Nț�o�7�\w����x&������6��]�C�7Lf��ÎV�+����+S�J�E������*�HW��̣�x�7���re(��.G�M�'��p&c._�<N�I��y�̄`�;�ޖ_�٦��i�t CbP����Z*d�􊭹'����7�לL��M�怽���^�X��J|�0=DnQ<^��k��D
��9y�NEeC�9C#��xG��i�C[�p𗧘DPwYFCr��R��ρ�3�	q�K[�VK��R���(�V�&��q^eU�s��#
N��͕�JoU*f*�2=�[#{2�42�;G��t,�m��s��-4s�����LU�J�X��_W
~W��u#�� ��b�U(
���2�c{t�ǿ��M����w�����Oo�\!
��&r�z�#��C�躶��5��x��,1EX��`�����đ��ܦͩn��Ke�F}��pRyx3i�}G�oV�X&�%�\�SG �)���o�B�����)/k����w�ȳPm��C[�#��}4Dv^Wj�G�7��#UKΎa��q��K�M�w�9�j���&d����HL|�9��� ��7e	�\�p�"�9`�F�M�RF>aˬVԫ�8:Qb~�p/��^�֣���ʪf�c�|�4%?֡�HrL���2ˡ�Vn���q`q<�U2�H�G�p��)t�](�s+��D��8s+w �j����r�|-\��	YZu����m�;1Y�;�����beS�xǅ0(��1c�64��J�"�.�[�Q�`�tB'��ғ�o���ڏ��F�m��
���A�8�!CbU#OsO��-D�ȍ��[�P��3�lyU/��G&W����e͒8k�Y/�]��AM(��2�K��!�ae6rܒa�%�����
��j,�I\dCC����
��S�k���G`sg^2����#�{�%�WJ7��j�!�+�O]��`{�%]l OH��<.��m�ȅaZ��!D��7�(PP��N(�Ã�FI<��"�k��arQ�I�
�	(�wh�\���:���]��A�z��o���w_7���xۣn|�P뤑��V���k�H��X�;r�����dҍF���
�6�����!��b,6e��2k��&8��"Xi�Ɩ�w fy��P�W�o���Ep�e"CI:�T��kA���V�k���j��bI@N(7�9�������V��v�X6��OS����D5֭fy��o]��E�`��j���@�4��%ħ�4n�M|�r�C�w�*3�f��[x�U���g���'��ut-�`N�˰��� �af2YqU^7)cuD���Z1��<����!�O:���^���
���l#��	n�e�N���6ѣQ��ɕ���`��3t�W*\�	~�K�O�,�.yxxBjU\���{/B6M�3F`���ڂ��x�«�K6,�������x�*��P�ӎJ'GJI7,�д�T��c"��s7��,�Q!���F�!G^�r����e��݅#Ơ{6�հ�j�]"�+�0����]�\��:�)� =8rs2A�/p��F�ؓ��97�<�+�(/9�d.���˱	i��?�$�e�}�G\�E{��'�MH{G-���C��X������\Y�;n]������=���}u�΁��"��e��6�ap���ZF�-\6��^�'�ܶ,�[�j����<Ɨ*\*$���Q	�x�����f�X]&iӂɲ��t�K��e��C<��Vr�� ������o�wy��V�r�@]W��	��Y^.�B\g����� �Xr���p�d(�3�+V��>���W6��>�
��
��+9�Rז�%1l(���pvO�@@��(����om��Oɗ0{�xT�@���9>���o�|����£��ʢ�n[z~��mq��$��L'p��\ρ�L��Y\�jb� �<j�����V�V֞�|i8c��    �#�jE����9�"gE��U7WnAq�7�d�#.��pQ�r<T؈>�EFV _E{+}�D?�[}�A�E��e�''qIk�u��`���\���u��$.��l8� �f�G�F(�]2m�6m��'�:ty�W�)��+�u"��ZO9[�̞�쏄u��	'D�9ʭ�T�5���V�����(ܵ���K�}�+���zﲉ��7��P`y��qRi��?��I�(�X�^�j]�ܕ)�vkU?�!b��A�4�`��J%���kᲙ�I�x�E�YƊ#az혳.X_a\d���'|#kA�.�^S�2�E��&�7)�xG��o���n�So�j+�����86�$ ��I�ަq'�6��@Q�~;lB�X��"�U+4�pE�U}���V������P>X82e&�br�<�f�w��K�b��a�!�q^���� �JOܾQ�V*��K=f�¬�9�y���OuLN���M�*���𱉧t ��:U�����f 
�~F[u�?D156��Z�
��w�?�w�� n�&d�����qނl��Iʏ�8%5:a�Og�'oB6J(��Xy�N�m��RnQ6��Z����۩sL3�2�x"�*�ݏ��m�8� H�C2~�3�Y�iU��*��.Z4W��̮��<!����H@ݐ6�s�6r���O+�H[k��^A��� Jm�	���Ѹf����N\qƩa8��QQ\>y��´	)>���Y�$����\.v����𠋛x��;�as&t8��wG,�6�k�7��f�1	TxBZc���FO7m�`�@m%���n�hK���ۥMpd�kTD� t&W��kr`tI�﫤�w1c���l�����j����_�uhf�E�/����������{n�	���e�K����A\�8[W�����2�-��9M����KZ����p�d,x��f�|����g���/[50!j+�r��b���Xnu�*�#6Ւ%�X;��!D�6�7�L7!,� ������1!�"/��Z"��:Sۄ�ic�`=p�5<3y6����A�20����yr��`;����l�J���E��ۄMܤnK?�,|���0�s��y**Z��-u���{mӷ�z���IF�d��@upԟÁ��̹>�V��h�oz)�KN���d���E��t
.��sl0]Xn�r�5�����P��S;��A�q���JE���cf6W\�_�LGl�V{��x���b OHݤ)*V-�Y�#:Do3��x �@��+F��&xG�Y� �"-r��[��<�wd���8>�	r�s�.3MfNi�K"���z��g�� �9"C])f�������q�˖�M]�[���RVT���5�zUry�
jOM��51Lq Cq�/R�����5����	���#ʅ�P�Ǚk�A<!U��_�4�!�M��K�+�
~�2�{��X��s�|r�z`��"x��,M�᳘����%ը+XKٴ3�eg�>K��JR
L�=��0��>Ш�7!��A#�'�[��4���lЇ}|���/Ҙ�(Ox��9Nq"��Q��w|��ك�Q����u���ȳ��(��c� ޑ��"���1�.ا���SX�>0Ihz1D��Y鳀�=V��l�2C�I�[�����������%���\���Rd6duWYBs�������(%��+م���;
@�R���w)�9熈#�c ��o̑�<7@E�Fo�%B2�.B�[=�.
�n �����*CkB����G>��e�O�~\(�ΐ�5�P��� �fc,�,���<!?y�wz�}/��#�s�Փ��f
�5���8��">AR^+�[s�uFܮ���ng>ͨ;hh��@7{��:���&x�?|���ҁ�`Vە�f��j��5mB^�s��c�/
3Oؕ�>aYr�qﰙ=���Wʵ����9���m�r��ǛL��Y�Cu����aeqV���l"d��f=�#v�ɍ�o����	9�43=z�A�&���+`R��@���&�}T�ڂM��`���g�`Uɳ!@�Mp�3���Ѓů�`��+V�0ƢȞ.�w���QkrD֩�<NyN����FOȪ�t\����mB6WY�b*{��M�:J"�w�J"�V�&q,��=�]�ā�Blrhw4I���4��'v�	���@q�V�����m`^���k��	ʏ�22��00�D�d�=<鴉��\q��w��y���W�4�5�e� ��ו����7���Y�%=p�q�ӎ���� �Θ���s��9s�(�fP�r� �����b,9���,0kj$u�+������:s0��V^q�h ����x�m�i?�*��ӏ0�4wXx�Qe�b/�d��1/���*�H��M<��F����x�0��l�#��B1ή���b�k����p�K�M�~b�e㕳�K�� ۤ%]��mGS)D�M~��є��	^�{��L�
Nb��r3��uY�����E<���y�g {yB���R���n�d����0�g.�ZsX��ApdCf�t�$�5w�f�K=֜�&>A�b����n���|�)5���ˮ��׬�_�%�N�,v^�h�L�M��d�(��`�7l���]n�@XO���P���"B�U.�`�H�frv�܉���rd<�CM��95S�L��N�l���w�̓�ٔ#wS߶C"�MHUa!^1�M92׬8��6�	����r��5�M�#w���)G>\s���9r{��r�ӵ��|Q����j\���B��T�R��f�R�k�&�	�Б��,:G������eg�:4�U����fK���$I~5v�)�-Rn�?lwS�]�i�[�ġ�)��<�gkh=S��3u����Asy�֐�'$x]6�	��n[C��4 "`�~��^���e~���5d���C��'ȉ;�P�j��0����D���k����/�vg����`�����E�T������Y~��z�zp����ޙ\��b��S�x.�����m� ���\���Y�b���v �+Ã��c���D���F�|gch�c�Ҍ��<�3m�S���q[va����y��c�����7!�R2��K�$�5:�i񛐳AT�37<�619/Sk��1Lq�Ӑ7!#�*�)0Ł�<!��>�
\��b�["���NϬ��#�P#le؄�X�����wuO�1�~w��Mp�d���*1����SZ�~$�3W�[r��-��A��fDD��?zz:h}L��s�5�J�bTM�Lp���M�,l=`���v��.��u������V��۔c=�Wx��?ip��	�*�>|�9��v�?�1���w�.�O>@�S�G� �4�s�����kRM1-�E;��sZ��p�yYC�Mp`Sj�nl��:��F���nT�ƅCn�&��s�!�����*ч,�F�%����a<�tv���,�aCC��Kb��m+����ݺ	.���W�T(��.!��z���˛�FV&�]v���~<�F����.���(�� C�(��
��?����|���5ƣ�~�
��C��x�:��,�Ǽ=��j��-��$N׹��N�BER�̣�UN'%���~�}@���g��/R��g�XՀ�2kd暏���&d�����p,>Y���]�Z����&�{qZ���l,J��Z��k�_pH��)i ;��g�A�����_���7P��1`&ϣ
��'���9_��E�����C%�"x��a Ј8���{N2�V=�v����F,1a��_bx��@�/��˲��� C;��r1qf�v�-lq����F��ŋ8�0k4.�D�EHO9-	�^�}�X�Yhsd�r"&eq{�K�"d��s�;���[,K�V��r� uJ�{4̻�E�B����Z]���X�#2<�(B��D����~�i{Xf������4=���b��,d�ļ݆8R,�]=Ooȝ�!d0��y�ۙ�o��UZnS���E�s���E�N9�#A'���0�	�L�&���/uY�<Ijc�3� �  ��/�x�%.�%'�`0�@-���!����x_r���:�*ά{�^ 4��b�����V�9��a�$�/H�k��*��c&9C�Õ����Ta�nI2��M=۶o��L�I�Z  <�W�D2,�O\ꅸ8�x1
<��|9'��*�+b�C]�s!�D��_8E�'�s�������Y��x��q���`��Qb<�[�|ϰAf3�[�e<�s��B��1�<H�w>7m=�<׋�PS���t0���C_��Й�Z�1H�j^�.�6�<hN�:��|3���2��t���_����EJ�n?6tL�i<Jm\�J�w8n�^+Տ��`��F�𸤱`�oqi��o��d�Il4���77�/�͊��Y��	�c�ʊ���Q�ҏG��]��V��c�G7���d���,kn�T?��հ�ףGt ��Ըx�?�J7M�m�R�Q)�lqt���C^/�����ʑhX�'8�ǩ���c2�T����z�Kv�y� ���g�X��*!�"y	h�����f�u�������3�6q��O�����ƾj�	�,�mۘ�/��Y�d��)�$��n��C��E��t�C�,&��<G8����0�Dr� s1�2$����ke�K����=�8J�ϝ��~�[5����#�y�+b[�">��k@&�B傧�g�-�3��^�&d�V%�pԦ��!Cڑ��{ꨇW��&����X:���݇�|� �j��w�.�C��i�aj��
�$�I[�Mp�`�/����@�0��Ͼrc ��(����P�J�":vxB�m<�~ ؋⭐0�R��C���ay�?`D���?���^�����.�����3�c��>�i&jו��+�c^��W��%�kP�"x�#(i�7�'|��g�糝F,//K:Q9�"�s�8τ���} ͘�����`I�M��oK�� C�g�c�)ek��i `?�&d��,�
h�� /�(�|����*�t�7Z�p�!�\DC�rX;��@�_����%\J�	n�j�f�aJCc���ɠ� �nr�8b߬ �.ɇ;��������6�鏀�!t?LN�_z;���E��.B˭������v#<![o<���#~h �4&���혅:���ctO�����X)� �����p�,�mI}č�[�PqҪl��t�0�K��j�U1W��,�5�it#�־	ق���V��R��)���,�}������4{��'[�v�*=_��u=偽�T.9�h=��Œ��<#=�}� �w�܄���y硴���;�nEp���Ҧ�dƸ��lPw��w\��y`�Գ�Tٙ�)���.Y#Cm@��C����~��k��!�g�VbN�6�C&GZ�#��q�vt0��"d��ȁϡ�&��X�I��f];���0��ZѼ��������6���vԶO[��R�i_Jf4�pmo�7`�gg��"��zf�h`K�3I;T��������3Cل`t
Mjm�-U�b�`��&]���z|Ak��p���8�a�KhG��ƽ:��p:'��٧�3�82!�I�9���+�)װnf����.k�8�� �
D��:�=���
�euO��G�q�;(��Y�#��<�#N8��Y?���\�R�M�y��UJ�p0\,ZK�}��J���8r'�w5�iҧ9'�k��:ʽ���M)���ֻ���ft���	�=5}M�V�8N��m�>���;�Wğ����~�?�Ĭ�           x��T[n�0�&O�M�w/��0v'�@�A��ȎhӶD_a�F�Y
�]�I���C�D-gfw�,���'�Ω��T��(u!I�,�'�Q�NO%�A����KYڗ$%lM2�:�K� 	zj��Ih  B��?J��}2��s�n��06J�@�� ����o�S޷?j$�t�'3S�2pl,�I/tT䀞)m;1�Ɉ�>�Ѭ�y�s�X\9�˻�4����#n�7!�m����,�=*K�I�$Sb���H�3�Y<���%&UЄ��o-�׈��4�v���颎�n�����k�q�PS�K��-�����x�	+Ƈ��uq^;�"��&T� P{�a���u��`�֬��A���G��}o�ra���";�0&�0׸[�ʨv�}w�^���˧N&�YL��;	�_��G��iO ��e�	]ˇ2{�D�%���\Y���=����\:��r����%�̈3�xt���Θ�O�7��v��pr�c����t7Aw��*�u�5�W��;��{����S      <   +   x�3��4�4�4�4�L�2�pL�9��2dePe1z\\\ ]      5   P  x�uXmnd9��fe0�cϲ�?��~DƚUE�����Ė`߾����g�|�2d�` � �^��c���"}���$s[A�1� m���"	 *X�55v��i|^�^L�������񁈶X�����&[R���T��c��U㰃H��I�������g�}p̈́�R_=v!`�0��Bf�5<�����i�7��|��[�ce�c��<���=�9|�ȱx�7��ϛbֹ��7�Ɵ����1Um,ػ���aR����׏ٰ�7+�ó-�ϯ�ê���y�<�=��/w�/܍�B�_�|����>ot��N6�Q��{���ؗky��+��De���㮮�G�P�
��-�������zO�E)P�i�͋�o[����#�6���3�vJև�O��U�<j-�e�lW8�{.�Y�U'�����S��AC?��ʨ���vg�d>pw��{��~�|�H�/z���ޞ�rw$a����������S�F�O(�ɻ��m���L����e��V>���e�"��#�}傊Ld��DP�RU}���>�,�[���8��\r�^��u�uL�#�;��.s����@��J�щ�YO����܉X�^��a�[�B�{V����]2"k���MPb�oݺR�Z4�s�ypJ=��<�<�Q�oaT]��Dp7����=�d�H{�!�m�+ʑV"�/���Ȳ�V�&�y���nt��o�����(:���ѳ
-i��ى<�UH��\���R�:�S{�J�|�
�В�Rx'�e*���(�>z"��$�1���pL��A�*��y����z��l���>���H�H{ ���=GO�YO5�H�4iA���z��yѓ��i/���N�[E#8A8��jP���t)��ԑV���1̾io��MY���l�*6f�ϥA�Mj'�q[Ŗ�����Ap�>��îə��*V���Ul�#��~;���~*ptƴW5W�����5�J�f��=Z⏞<�cjk�5��R=YFʽ'A6�^���-�l��ק��DH� ��hD6d�W��w�^��0�x^��l�=�Sg�^��0�\��$����1�)_<A�I{3?}�2��5��߹)_�؉���dsaMԾ[�d��K � y?���q�R��h�!;G�8Q��Fp�<�w�4�v.ry����|����{�3�/p��Q�x�!�}٭r`>G���z�����0�|�}T�9^�	s�\z.����]�3;c��]�gM}����a��3>�u_a�n��7y�xD�r~��;�]{��H���e����^��i�q��O�6�˦�;���_-��/�u�(={c��~4���kj����????�+�N      3   �  x�5�I�e!EǺ�
�K�ux����*pеG-�]���}j��<GG[k���v��㔸��ZU"Kj��>�2�zJ�o�S3C�e���=����t��8^r~��eKb�{,�c��EL�1���9�?���[�l�|F
�7D��N�\ܘ�XQu���5)���������1�XE��ռ��c�'Rc���"!Z�i�T�����^����&>w�z��4��UA��1S�cĊ_/�ܫ�12��m1��s�Ͼ���O�鴕c禪]��=�Cʗ��!5����c#�t��ń$Jl�'�j>�D�kn%���m���JK��(��L���A��/�K_�	!ke�a�P@\/��}�G �)?�_k(!��I�w,��O�R�������f����-��6�WY�b�Wa��%���rIB�Y�m�[�B�J�r&	��,��O�j) ��q��f
X7��j��@�[~�	�ӹFX����hBe�$R-���_I��7�O2u� �}!��4���9܃V���jI� E+��=d	�6.2��M��_���ɚ'9���ĭ����t���.	��� ���e󬸬�i_(�4!�X��k�oY���9!������ѸZ�H�E�_Y�85 l����P�}�4�ICo wO���ó�A5[@�)��3�2�*L��3�qD@�:U����M�'�X������Ҍlc8)�N|Pܷ 0#q�;���Ǎm��.B�����ƈO;���?� ��X`ch-fC^���Y�˧x�ur�j6U��K:�Y$�����K	����Q��3�����B���[0}\�r?�#�)���~`���&�OZ�ض6k�%?po���A6>9^_nb�60��`y�?9�H�������R�}9J�)h���S��(P�:8�����woDZT�U�(#����7|��Rs���c/�a 5Qk�,�+!fa��d*���T��ʍB����_�C蟹@?��#��u�B�	�'��Y�� ߌ�hVɇc�������{��/˴��t��"��-;c�C��Ơ$�8�.�ċ�yC���!���ܡ�=�I�̭�H��P���&.Bb�['�Y�y�Vc.��PeǞ�m�h��p�� (��d�2��+���)���f���rF	X	����qu�E�� =�f���A�df�-֌�u��d�6o�I���Y�6� DlFvk������F�U1���]4D9�OB�.�P�/w�:E��Ab��x�'����(�=���@����|LY�W�j���9�����jq�y=O{��(�K��3|M�� �
��(!K�=�,d�f�%%�E�-I�f�,����!x#���o�Zo����CU@:��{�*��[���ࠓk����o�b���l톬m�6��7w`4�J8$o݁���4�YM4Q�͜ns%V�^��/��H'�	f+wS���Yā�,��e�c����g
�ܰ�v�|*ci���s�t�4�      &   �   x�E�;n1D��5�8�Ar�-��)\%9���/�#�Yb
�%I�z��o���$��p;��a�e��,�uh��0�\y��\��rU;EDs{JH�3sf��ps��J��	�b�3�`��s���������X\�_������*�;~nQ��:��ױ�ڗ}�"u랮g"z��C`      ?   B   x�3估�¾�/l�����;.l�2⼰��V����Mv\l *��6漰,��"���� 
.�      A   8  x��A��0���)����~��8{N@w��JS�V�Iդb*�T�-7@p��@t��܈��Ӧ�$�]�����쯉Ji�h/읾��t�����{se.ە��^�u��_��2vB�	��%�\��ݧ�b�A�G4_�����b~�o�׾6ks��k��_q��n��n�4� !�w=��0�G�֣�2!2�8�1"���݀��'��r��2�Zo켔���H�BJ���%�K{;�dl�,��d�a,y~ݨ�η
ݮu9rk��fQ��jQ6
Sj
�b:�s�
b�7��l��� OF~|�6:��˃�v���3�S��~���n���4��\�f9۴ULjUj=Rc]�l�f
7{���37FG��[�d�Г|��;	����ͤ*w''�?n�ez֤e��T7����� ��p��"	���]��,Eq��`9�.�\����'����Ίj��V͟�i��.�B�F	�R�D2|\�t��{D�?{��
[�0&a�m�e=���؞b6^`|�G�y�W.�̺�������E���v~���_ק,N      9      x��][�Ǒ��N��e�;/�'�aH�z�J�D�&�D��$�Տ$�,��W�Ѻgf�Tw�TN'�HĠUY�>yo��tx{����������������+��	~�������s��W.!������s�/�;���=|�_�w����=�����?����{��;����wr)�H6���f|�{��/����K��9�����������޾s�~��9>_}��9?�K��$+��/q/y���;�Q��g?��٘}�R���|]נ����������;�*X�{�̲��.������Ŵ6y烳�;�){os��w�\�sw.�Γ�#+�8���]�g�"3�iR�֘���w���|�Op_�/��1�s���W�}�[x�pw��M0ŊoZ�s!ś7/�l��2����^���'P}����1s6��X�O�8}حv�V$���������n��f��~�+n滺����~1�Z3Z�����#���d�hc<N�kf���m��/����x��4�JL�/3��`����z�����-~�e���c��\;[�Zp��,Y�W��]��g�c#�壍��w��{|���>?���������۾֖%a���6��(�e,�����%�bqD�X_ڎ�}���q�����^:��������W�S(.�g]e��M�[��������ǟ�lq:�����z��������&Iƚ�)��N5�fo��!�~�W%�{:|���d����������3��,|�pv��=FQ���Htv�+B1^P�.Ȩ/�ɉq)i`	s��ve4�)9v�v����n���dQ�����K�9��A*��_��z��=ƽ4�ю�	��O��أ�M��фU�S���J@�n��qӾC�ۃD�S,���&��c,�|t�����e��;�?V���rPf�F�����Ÿ2�l�?�/*!��L�Ϻ-�#�rCo�c�y���zs��{&�OX�W��z�,��<���H�ƨyZ����z�'P�7^�b��?�g`�̥ ��w5!d���@H9cmw6�5v�h;�D1<Y_�yh�;��Ɍw������P:f�9�F
�Q{,{�29 :����`&�h� �#�V`^�Ļ����};胍t�y�0��L!F�rA����Z݅�y���D�����#��7��Z��T��:����x[_vZ�/�t��!!+���<��"&�OY��(�FdsA!��/��<͇5~�X������j`��>��UL��qp��S)3o���-&�-���<"�q������-=i�%���ws�V 9ƙ��Ι�w�4 ��9�Q���C��O�_��K>���r@Ay��j����Xo��c�'6��[oG�1P
�{����7X�[��ˆ�ۺ��]IJ8Z~�
@|o��a*��`���Ѣ3q������#I	\JVt0�!�Ї׎_�&4���d����g0;�s���F��75ޅۅ[�Q~}�r��1:)�^
!��d����}���a��~W_-flU�DP�����V����
~
@x��pU�@�Ll�V���U3�1ާuUN�����Z��%���}�qҰd>D�C3�b���1H�Έ����x���.
���?�� �/��[ayXa֖��K��̽���0⍤��x{��r���{Zb�2)=[���rp7'd������1��7-���B����;\X�����c�x�i&��׾��61;k%��'��aC�!D�@�Z��V���t���#�����B��v���z3�=�]H�̏�! �5O��!���cA_�%?]\{+��;���xi�xg�f�R��{����S�Ɇ�5�[D����I8��R�5��I��̂#��c��~�d,>^��Cv��h6�9� v���ۘ�ZX:Kv�!)݊�@�?㣤1��dW������)X�C]��jy��ќ�e�Dw��rt�-�J���fC���P\#)|��AXE���t2�e&&����lq�QC�<��x h�/�7�
�@g#��r�HEpѪyʀ�tp�]�n�Sb�q�!�S.��C���Xuŏ,�z�p�xȸI�4�k��+i$ 9��O������BM��L���?J�m�;�a_ɸ���X�U�l$pD��\E��k��ϫe^H�:���(n3�Z��)&ӈ�E�=�|kx̵O�ۅ�^�=��6�s�S�3Vrs9�K����`�f"�.#�ޭ��wk�$g�x�DA�YĴ72�tre�"P�X΄�3��y�IS)<�%
�o	�ĜUK�>����3&WE:x㩬*Lg6��ë�Z!}��%|�1B&M��x��x!��`�	���g���%%��y��i[[��<�ڈ��rf�0xA����;�e.�]u��e��-��5c�QO\L�"6���,�WD.��XSɛ��i�c�2fKN�@|���RE�Ͷ6+�fjl#[�O5��W���l��S`�{{�����`��y�o��b[uJ��q:���+2;���t���y�����^��q���`c��-�[�Ej�E��,m]��y_H���_o8���9���0̧�CS�Ma�[k%�G$!s3F��^˷Q�k ���$��P�J�P��4w{a��o�u��c�t�6���j�d�Z/���U+����Ku�f0�6��>��<�ڭ�ty����I�v6��:���<�&z�A��׈�ٳ�	Wt�U�Ӻտ��Q�(�;P���I�� l�	��FA�� r��yS/��� x?�d����D��x�~��B��p $��lPL�%�ϋ�۹�֒��R[&��x7���S�����r��b�g��\���*���L�bҟ?�΂�=b��R��UG�%幆C�ZCs�m�Gn�4h$�E�,[�D������vR��{�[�@,Ī���0,�t
[)rMVt�׶.L�F�{zg~�1B,c�+8��Y�c>Uhy<1�7����x�D��0r`��9�����b��ٕVf�Иp�?�O�JV�8����M��R�?�l�%�KQ3*�1�)�A�d`D�<  ��y^���őc��sNy	O $�ǰ'���5&n��y�&�����u�}�7,!��r���M�s�G+)Y�r1���Ʊ�6eX���,����nz��.�|\�1Zm���eF�e*�M2�)��L$k�)�C-D[)ݾ����X���=�]��.0qn¤*p��T	�X���!o���h3,��u��8v\Ji�G6V��I	;�s$:�jY>�>�F��J�����=�W<�O��^b�/1��v�C�@D��� ��c�ph���0hߌ8����'���vC]��-�i�*������2|}U�8�Y��e����3\��9�t�aq糄��!�P�+�������v��z����v9�B=t"�ɯap�^.�s��N�2�>�hƒg��0�VW�̱���^�HBWY��N��41�:�Ҭ�X�M1S�$��`��s-�'������9�̊):á�F�CA�(S@Nx.���h��(<8�����cj��܍v*��M���߰|����\��>�}�i�ڥ�L�ol���!�9G��#<���Q�Ôl(W4%0�A�ܥ�hZj{����)�&��p�Z']A����3�i�N�߭�1�&[үƔ(jr��;k��Z5��]�/y�`�%ޜ�CӎA&���u�Dj`��&��o��o�����,��*&*���$��p�J�f�\�����&0D�I$h)2�b�{+�)�r��>�$6�j�������*��)C�ͮ��F��9:A\9�j���҄[v/k����ج�o1�{O���������]�&:M��n4�/����ժMv`K!�`M(ǻ�7�2:�QB��o�O��J��t�RL׷�A�K�Y�l�V��!�W�l�����IR�ۛs�>4HF�Ɉ_�h;.x���k�?��N)��z�v��%sKmKs�ΙJ�s���z?x�����    �p�������6cѬ�Q,�P�kr��О�IA�d`���f& Ȫ�G8���q���J���pqϏ?x���W��� ��TK�@�Cs�ց��:KRG���{�k[�ts�X�鵙\�yI��yi���\�$��=��ڮղى5[���ڪp2�n�V))�g�ղp>�������^����P�0ι,�$�-o�%b �I4���k�S�*��Va�f<�0�w&Iv.Ǿ@Uy\�Uj�ͱ�q;{�M��7?Iyx@���[HD�aN�$Y'Q�~��>D1����;]�*��y\����آXQR��Vt�X���s̓d-��A�w$����BV<@�F�C�����PbJ��C��A��W!�U��ߵ��X�������"�wf�Y��Qɦh{��}��ޙjdɍ�7F�̟&�>p
<��'���M����!��G��Ԙ��X5�g
S�@g�(KS籱T5�S�S��b�}��v6jK�ãnv����l��:&��"�8�G�e�l]�w��*귋I賐.ْg�-D/>.i���}�neh��S���ά:��_��$��ZWr+`���5���ø�g.�8GrL��{R�ō����)�-/���ئ���'F�A��,�����d;� �k���gu�6[��3�;U�6CL�e��'*��i{>Z��Z6]�����h��q���{���q�$��1x#��3�o�䨚�YB����&+ ����t0Z Rܯ�t�|���Uj��źߓ7s�G�QE���Z��ʆ(b�T�g�:�®>�N�c�����$q�s�gk��G��9U�	c����a3K���'ǳ��z����*u{{%g�c�q.����4��#���	�B=��e1g� �T�K2F�x�]�K�fg�*c?�\�������4����#��Zg�t�O��t�9�D���:�ԮϏ�ח�^���j	���M��^Ȩ}K)�ܟ��b���lٜPPd2:��0v9�I؞%�/��V2�>�ɴU�v�V�K��B]Z�[����;��^����LiL������s�m�}T�#)�љ<�P�����җ��Y܏���4Y��Jr�5GP��9J�VM���^Z��W��_��[���#9�:�}9�V�0��ű����r4[2 ���5��"4ԜPhp�^�ּ�*j����+����7~^�3�J/V󍞍[Ʃ�0�{��H�|����N�m[������5�
%�dث,qV*%�.�U���[Ov;2��s*>�v���GO��� �<��|8}�b�ȁ���s�笭IF"o?7�f,`�4޺T���b�1�����ڇ���׸��N1ce�'֛V
v��Zέ��o�m���ka�*{R1H�����OJ�,�8�ML��+Y��p�ú�_���n8Z�ܽC$7�!c3���K��?�����v'o��Ι-얷��)� ����*��9�EzwLO[Ԡ��B4�<�#R�F-h�&c�q��Dv���m&��l<�)`U��8nGc��n���M���\)�������z�� �:r�3��9�H���x��Xjn� �<<;�V��� >�4����ؾJtqESL�%Ɍr5�Z�۩V.���'y��	s5�$���Q�b4i�.�]� �M.V�
D����L۫-�SQ���]Ҙ�n�*����&��t�|s�K������2�N�-���!;����1ABd?�\�<[�ZD��o����K���,�&)Zs[(�|�H��L���AK]j���q��g'T�����-���(2�_~#��8�{
��g@�I|�)Tq{H�S~�]�>���2�yx�f��?���p�T�s����*��eDV�����m��=/���_2����!�PH�06�
�����B��0C�i��G��(Ñ�<����7��.�և�(�2e�)�ˡMc��T5J>�g�n)��j�Ce]�+'k��.?�š?'%��G �+���m�Љh���Q3�n$�9�����e�dl�w4؊ ΐ�����è�=5�񈜀�fc����f*�
�:����f80`#�Pȼ"�����26xQ�-6iN�J$է1���LY�Umv}�6붽��kZ"��X���CmYTN.@hg����^�Sl|�N�[�������e��0��p�f����d:u=�9�bL�4W{�nO��e��4�ɜi��Ê���tܧ[���k�%M)�Ӵ�[w.t�/sDi ͼQ�9q��޳H�f�;��3E��6�M
�1��ck��[]Xlݔ������n9��7N��D���A(9�s&�*y�47�9y��97��J����)ZMv��`�)��d������n�O�_ԟ�<Pu:dH_�����PՆsWuQ���&WRf����2����Ld�ǟw3�>�F���� �R��4yLZ����E������m�$�����}����nd>V����"6E���)��=;�T[��0c`�D�C���\�J�#�%!�̏�\M1,]�b�5h�}��%�����������sГn��Vmq���d)��ZD���f>nZs��	g���&7�g��LT�a9H�������S�ٚY�|��B��3��0�*��w�<��kT�=�k"b$ħ�����Qi����06���mg"����N��Z���rl�1�C��عD}��)InG���o�w��D�V�����X~�=g���){c�P���lT=!pnb�U���8��1!����hԭ�U��syJym�X�&a���̍^�8OM~��E/ꤡ�oӨ`�%̥E��X3�끣C�9�K}�*�LD-��-Q�HE�O�6�De�Z/���X����v8��Z'���뺜}��������iV�؅=C�
hl�:��^�yV%�C��B�$��������|x|�^��ֽK9��s ��P�p����Oq��1�#}�\���)�O��q��21�z(�ᐱ܊N�/\�9�7���z���ƛ����X�D&9�.P)v�m�u�����u��m��ȱ$C�a)�$������88]rYDƓ��2�C�9��<I�I3�r<e�[������p��j���w3GR�8��{�YM9_�����bRo��R;&�x��[�Ә�$��Z ��!�AW��ɺ`���9����{k��i�\P�Q,C����P�tJ|H���,�L���%��yOlQ����]�hI)m3�0N+ټt�l��-1�ʋ)O·���1��	���E��r'c��d�1�Q�a*���J0�Ay�9���&X`�?cZ�3�l,�Fnj�e���x�A�*n��.Ќ�,�F4.-�N5��]��r�[�=����,wL� ����gA5�D���
����`;�x"˹�W��ܫ���P�
�5����9
�3?�o���d`��Idc�&�xl*'W�t;��VlV��������=�	�\J��e���Ms�]1�F����>Sd�j�a��/��4Zs-69�g�����{�������FF�E掞�
��p�6EIwG[�6b���cn�h�23[�V4��揲�7�>*�X��kt�]�$��%J���x�2n	�̸��A���h�&�c���Oj�g����3�#vLO��M���s� NKsL
 5θ�UVr�*�Z���a[g%\�(��!���b���RLJ��_q��-2'�٦�=��l��<F��,B�����Ut��;��ԁ�Djܜ@�N9���w�4�),g
���J����Z��������� �)F3z�)�1N���&�^0��jr��f����a�e�X��_f;'W������V��J��Lk�`զ����f�*U>S�㞇�(��)�-�eDꀤ%v�*�=Vv頙��A��Ӥl�s���1��o����t�K>�ji~8;��Hո�c�r)�1���h*�"��<Ax�zˤM�F���g�K\�ɕۇ��H��(g��g`}��*ᆀ�g��i2>�<�Br��hpEC�}��<,�d2o y�dN�8m���� 6�]�\_9&�Nn��7��A{q<�PF{ܛb����6?a �  ��(���F�86y20�DZ*K���j�ٜ�<O�h"@�s��ӛ� )�^��W����� >2~�#��x�����̿/į]={ρ,\�+u���d���j�U(���-'�,�?�V��%��@=SU#�4֎ŋ8Au��B[4�Ea�:w�r4!J�0������O�e��~�[�q�܏3e�ۿ��]\:/:�Κw��S��@��JHa�f�/���5"J�1�3;U�w����]k�~��ﰨ)"�
�5]��T��^M3���2�'�r,�%Lr>�X|b�]B�4-k:+Q�ҹ��dC�X�8�Q윇�bڭOt�-�0Ք���_)n�ж������I�B���U��S`�*�x'�c#ytZ0H 
�.�����Ӧ��8WvU�]�U��/����n���Y?��>e���j��>��*6F9O�2_��� �� 
hQ���d�&��=�(�hk;�����F4��\1�pf�T)u0��o[�/d�����G���㻇S���V	���զ��*\ș6��OxHOE�Ɓ���*�W��w�A�N�ɘ�!F }� n-E<]z�)�S�*%-}�Z���$1M�9J	����0��E���B�����CC{{q�:���Sg�n5�:{Ҏ[��3ӿCSQ��S�,@G���L�7oGR����J�9�*,4�T�1Sٌ57ɍ����ح�J�#�S�Oڜޗr��K��n�(���������t"����Pg%��$����S��I=|��쇐}{j�T����P?W���_0S���sU)1�:9�1��i���ֲ�=���m�/)8��'(�/m� ��<f��M-g�y��jn�\S�R��8pg.I�~s�Ț#�-����V�N�6���Y�3<u%�u^��&��g�$�N�x�I����i�2[s��<���z7���8g�̐V��Co"�_��w��P��ׂ�ݭ�&��R����W1����y���1Z�<z��F�K\P.��6��� �X��No4ԑQ$FPܠ,Ĉ��a-��iޝ1:�r���Ү(�T���&�U̵@>�W|�w�	G�mp��+��4��J�2`�b׬��V�����(fa���^s�6���f?rP'i��B��5���۔g,hҷs���9c�n,Y�#-�{���������;��s���~����s�-kj�s5��׏~���e�y             x�3估��b.#���.ccW� ���      /   �   x�E��	�PD�;U��'�X����$<	Z�hA��DZ������a`�y3�>�f�{�jT�Uè
��Ή��� 
�5�r5�q.��s>�!S��ɩȇ��A����6��u�6Vnwe��LG�����YW      "   &   x�3�4�2�4�2�4Ը0W�˄�L�r�r��qqq n#~      )   /  x�-�Ar#9��c6 	����cY�{�L+����鎉����]�]�]���y�}W|B�5to���ݡ�C���P�*RE����_.a-a��P�B
*JE�(��T���b�X*���b�����0�}؟B
%,A�V�Ul[E�h��U��V�*���_�p�'��B	��;��A?�yЏ.�~��o�&�JX�Z8��᪸*n���-�p��C|�f�e.s�msL��6܆�pn��;��c^�1�4�\�6ݦ�t�n�m�-��ܖ�r[n��;)���g��f���f��W��=���w�?3�4�\�6�<�n�m�m���ݶ�v�n�m�=n�����}')���4�Z�0Y�beXV��aeX���#��~]>m��AW�wʬ׭�D�ڨ�A������J��+�J��+�J���$+I��I��I��E^��/2����ԓ�=��,�
���XJ���Gɯ�Wë˫�W�_|�@��f�>k�F�V~���'i���O��H���c��G�;��O�Zh�F�ְ2�C7tC7tC7t��������eEG�<�R�HJ�Zh�Fb%X	V��`%X	V�� �$O�$O�$O�$O>D���+�J�ZUh���O@�jZh�F�,F��ͧެlV6+����fe�Ҭp��,�J�Ҭ4�v��y��Π(Q��6jD�3(�2�+C7tC7tC7t���]�����e�rY�^Y߇%*��F��_���W��φ������F�t-E)P"V��d%YIV��"/�"/�"/�"/��?�C,V+����be��XY�,��i��i�o?�����������      (      x��[�zG��<�.��Sw��]�alc���ذ�����b7����,�f�h����3#�\@�T���Uw�^{����i{�λ�I��ݶ�v�t�����_�mf����E���u λ��������y�~o<y�޶k��' \uO�|�=�Uh�LSf�^�ðn � rX�2���}��ظ�y{�Uj��I������a���yV���p��n�}8�U�$k��3�yѝ��0_f�{���ę�M����ʌy�v/�<K"/p��q�'n�������� �F��dņRoW�v�j���bO�DD�����/������üK8醿�����@O�S�L���dd���w����x�n���u����cu�	̄�ސޢ!���׃��n�,�[��90�G����Cܠ��G0;}�x�9�9��� ����1H?���ȘٜN�˱ZP��OPF��l��o��h��T�Y����_A- ����_��ж2۠�d� ~���W��|���-���h��o�=#�`�'
�-�ǭ�x����#�r�������`��&�������$X��k�]e�bZ��hcr5R��c����I"3��2$'�A�i�e�tf�A�٧��ܢx�m�`��t�x>X�"���r<��? ��W����W��e1�q [dy�[�0�QŦ��f���Ӂ@ސv���0$qN:��bJ;�s�I��#��0��~N�U4^P<8�NE�T}���rI�r@ ��1:+r7n��Q���2FR8�yE�4B�\c&���D�:�O(�_R(�N�� ��	���r�5�(@��:�꿴��wh�%E
0?�&1�҇PR�u:3��?���F�P��^(�]�YΕ�� �?a�uϹ�j��>��H8��/A����"qP��Ɋ��~!��z��� ܊�sD/W���f�si��9���j�1�5"5쉨�9�*F�%�e����ޙ�_�\��}��	r�����s�� ��$1���JVvB��Nʻ�1qT#�$B��[
~�[G�zwN�I�i�@X�[k'h�H��<�,F�����J�o��� �@DL1HC`�R0���O��©7&�ن`�K��oYSisXh�dM��|�~�_��c���x��g:Es>��1�q�S,jlcA�DK��ԃB�;�'�x@�����;,�9@D�H%��=�hT���Hl+�/�Y�Ӛi�c�{��	0�Ka K��ˍW/��)g�5�q�a����DЖ!��A���cHJ��5�� $�iyf(�ݞD�Z��1���O�P���U�Qb�t�.#�<`��Y��b�>�k�Cn	�s������fK�lK��?���/��L20�=�����>!Q�����3V�I�}d(7�Y�@l����6���A�H�*bT2 ��3�\�<��?x�>jƍՃ��b�OR��� `C7���s���De�s#j)0�2�=�n�2gIn� �l�p&!�q���L���i"�� � ���8"Z��!h���r f#Iy�I�w\�P:~$��H�byއS�Vp���Ҿ�|De�AL�@,�cX;V�>��?"?��Z��wDr��9���P��b����>W7W� ���>'��IH#�cI�b�:�=�]6Lb)"�T\/��N���K"��Trqy��H���u/c�������4��1�ﾺ��n�H���3��H�h����\:��ä�a;eg��>�,<I��X�H^us�����`��)V�Z�?�
�SC�9���3׹ql�i���_0�g'`�h�P}D��VUT���%զ@��F�T�Sw�hd:[9nb �v�(W���L5R�������F"!�̈�b�ij�1��~-�@��"J~I-*6.��ZR�ס��e�d,!�չ��J1�� ^pO�d�P��W$F���U*WQ{�_֧����ล�%� ��W��i� <(�&ԏ�
��)i<`I5e���
m����*<�HY`���J�i�	��X�3�l��(�I����o�4��/�"8V�)����.p:L��i�������ګ�@;��6��A�P��v����[�D��h!����B�V���ݝ�i�I����ҪEh,�^}Oc�@=?v �l����DnM���P�n�+Z���F�ׂ�X��#���5Q�	�-�Ǌ��	֔j�����D�	���Z��#2��D ���=�̬���a�����%nm���,�'k�Z`��am��Ǝ��D�E��&m�Ǿ�lKu�-׎�R�F��p�������"�>�6���B��$�X^S_`��J
t*��Gol�� �(�nf"���^�� ���߇�pɗ���6�̃��L�5|s't�9��ϓ��F��}�ȋ�w"R��V��E,+�D�j�u�����}ߚ�/:����"�=�5�hZ�UJ�O�Xw���cjV���5�Uyl۾�(��[�E�Z_����U�o���W6���B�o���oJ��qPa\��{��N��8ضt��1�=gut��� J[&��z!�J�(.�|g�r�t�ћ���T� ^qg��k�<Bݣ�l�H�{*��}�4"�3������C��G�D;,�.��Na�m�I�b�D��rᾋ�d�.�N.��Fӧ��3vi�cA�k#\e�9�Vxꥨ麷S���x��������/�$TD�=�T{G��r���}����F�����]�^cH�*�v;P�G���k�=�>j@3�q9�eQ�>�a<`�h�6R��h§���woh� wz6�d�Y�V��dnGf(Q�W#��P�bv�;<��
G��"Z�m�:���un	DS^I�n:��Cn��D�k��>�����N�ma�CZ��+�{vo�'i�jz1����ro[4��d��1��f���Wi�1�4;�1�qwr#�ifp�8��vw��#G�8���"���(�xq�A�v k�KϜZ��x�t���횳��,�\5;��a�����hs'�//�f�a��s�YH���}��:�T�z`Bq����K�k��E,ٓ��qSwG
��t�i%'�0]sg$�%5�B�R�
��:/��)�.W����<@��P]��<���ϭ@u��<�q�ҹ�p4 =Α����7��+H����J?Cz�
vx�c��Z ��o@���p��/��@� &v��cgf�y��������S��_��8*����N!��|��TA�V�,A�����QIRR<Q��^���+�H�MK�Tw���[��4]�k����$�W�o7�\$eN��sE��:z��J-���Ziq�V�Q�؈{(���(���|����te���ٕN��h�ו�R3�<NZ��,��z���a�`f�m~.��CEn�1F���Ľ`X������!U�����,'\V׀�r;���+w}���Q���\���q3�V��¨q<g��:�*�NG$���N��bE�=��^�hW�z�wZ'q�	��;��c-r��knz�)�9}�߯Ґ��y������F�樓MMi�u?�=/z4,<�3���q�f�k\M�I��)`f�#
�����M`�RNS0
ߌ�_C(lK�f�������,�_��(<�ʿ
���ι��d|�	���@�c����SZx<9�D��� y�2�B��hN����섧T��>4�<��6D��޵<!���J,zr1,o����X6������g3Қ�ϖ��kz�|@J�HS�x�$��"Rλ4����ś�Ǝǩr����櫱 �9+�|��D�T=W�o�}GK�@iv�YP<��C+G��w�­�h��D��\�͞�r�]�'�Q�!���u��7#S����w>�<n����D���6=�����5��af�ӑ������y𑣺J��v$���Q5�*t��~�rF�}�y�^�[���SQ��i���ʻ���t�J|"�����=����_�wt���x�m���f���{
`�U���9ʽ��F�P)%��P�@N|M -   x��/v��m^L{�s~���f�������x�6ƚ��Y�����         �   x�m�M��0���)r����pZ	͂E%6 !�
Q�iTh�
�7���.��?��?zܭD�-�C�!�������/�V�ʽ�$3�˄�*G�;�X�)Z~����mO�O�Mp�']���ʂ\
)���.�t����hCV�Dg�芢��$�����ጔ�W^����g���Õ�^ �oM>	Ӭ�:��l�S:f'�S�VJ��4����� �G      =   �   x�E�]�� ����T���.����)
dܮr��t�}���`������R&F�):Ysc�?S��8�:@�Wi��0�Д�7{dBUg(O���q�,Gr�3�+6=5eL����͸m<�0�)8�K{�<����e�A�����И�lM����ВCZ��_�~ϊN�����qUp���P�>K.p󵄭%��zq��]�u���o�      2      x������ � �      +   d  x�]X[�)����9������1D���I�@��-���y�������þ`,�5Y��g��L�G{7,Zu��Ȼ�Z��/��(Ay�˂�Ԟ`�j@id��3�����3�x������ZN$�m�v�x�L?�A�;�A�t\t\ln��;��r~Ny��+g�_�f;.�Zy��p?���sa?k��5~]�����r�v/�1�k|է���C�õ�R��j�Iߋ[�O#�KZ�>�\�ޭ?;�b�~n��׸�=z��ٟ����z���>�(Y�[+�2�r�������Iߵ�lܟ�w;��1]�1�n�ݑJ�{���Z���OpP:xE*�����s���#VJ4���5�ӹ�hq�����qx|\��w�9N>����R	���V�Xj<�zf�����������(��I<3�?9�9 �"u�3�ӳ��vzh
�.pe���N�F����h�ֻ�=�t�P3pU"x�T�<�(y�[_��USf�n����E�|{�I�"�!�1Q^��B��e�lm��;ObWEQ�8�'�F�(3J'�Z+/0�(�3<�d��]EL�&��B<,m�}�ˮMa�����N��<¦1�1&cR�YQ�&���6\b{�L�I��	�Y�r�����"�Ǳ({��(Ŗ�S�b���g���b����3F.���($V2a�]�� ���=��*�cDhx=D�{�`⬨�R9c���Oq߄��	��
6�\͏�o]b����Vw�h��&�h�Ep�v\2�EGְ�����ӜŦ�(���b�T>A$mGJ����}���߯g�o�Ro���]f�[���F\�,�h�t7��|+��@�D8|��p��pu�h�Z>bP�ؕ(�s�����\��[je8�}�������;@�}P���ެ�hT�DQ�)�*IS<����3}�}���%v��//u�h��~��tv���5�!��0�Dy�LD�8��n�������.���V*���-�a}�TD�-޼���~�B�"� �/�He�����;Έ�K�"
u{Z�<L�y�Y�p�O��҃h��a(Ԗ�4tT*=;@q��`q���U�֨�&n�A]���=��az�bg^��.���+��a�%��.":3?8��haD9���#�Y_�<f�Z>��?#j:<�)��'gxoo�]�*�4�7�b36��(GE��>'��K��RIE�����}Oo{�O
� K'pzS����4J�~D �+�H�U&JϮ4�����Tz �*���kB3M�!\㍰�ؽd��N����6׫� �fD�l<!+�p댽�1>:ԡ���W�㋼L�;�?;@DI=D=#ޏHU~	g��Zh3�����}D>�"��ЌE)o�H�/�t8=���U!3=Nw�^��ih����[-��¿-F��%ΌvڷK�%��ha�=v��eT�(W��h��\�M2�?8ю{/ύC�y<�Ӯh�����=4��0:����<@{g��&�5�,E�/&���%�-]D�]���%�� q:�K�5�Ѳs�|��#,�Y���x36I+~�v�7&Қ��Kh�b�EG*�����O�v�X5Oċ��C�6
Za�W�C�,"��M�����	jX�U��q�2l�j��.z��>z�������ŋ��      *   P  x�U�]���D�����$ ����_��k�e��ZV[n��k������n���P���ﲱ����`n��W�om���[��z�S�-������!�-:�o1�۱�#Ǹo1o�)�[���R�8���c��]�8�{g�����[��7>Y[v��o9p���?Y��8���<��V�:���
s��������k�j�c��o5�s�����*Ž}wV�1X�;T)�P�����}lKHq��(��`����9S<.Өx�7��Gs�͑��,j�U�zܪb�)�7Ίǣ���X�H���xo*�18�w����xǧ�xǔ)����m���<��9R<�{}�3�;+�����ٿ�U<����(�x���|��&W��W�/����U�`.�fA��U���(^��^_�ߪS�0GGnT)>��(>�J�G����*�&��A�!�hC�dB؞�9�R�0;�h�7�6H4D�L���S����)R�R�����Ğ	)*�W�fmav�׮�+�4��}{�}	�ŧHX���%�P�t	��o�d�m��c�&�״�:$��mC�bBJi݆(*DRzx�.wX���΄��
�v�CJne���nY�4��g-=�o�
頭��<z��ѩTf���+�Z�Je�1�]bP� F2!��:18b�M��%�)���b<���?C��#��U(��!vέ ���bG)4������LH��U(C�\��`!0��
bR� �rp&$l>�<b��l��{���[%�+$lR� V�O��		[&��|x�����	)](��X�BA,�r_�x���g��y�x���ST>�u:T"��c�*a��N\�-��3w�!�;ܒb�R�!�PA6,)C�΄Zѷ6�jF��p&Ԏ�ɛ�!m�SC6���dm0d��2dP� Kʐ��Y�om8R���gBJ�b�FZ����ҷX�Rz��Qw_�b�gg�X��ګ]���k�o�~>)�}N^!aom8���<�X	{k�GL��!,O6��6LέjCV2!��6�|]ۓ-�^L���"ϝ�N6���g��G����}}R�޶c��|=G0!��uCr�b�I_7�۳�	���y��n�9~tH)}���c���R~r�����,���Q�\<����*]l�S���i�WB:hچ�|� 'GP�s�
	���)Lʐ��y��}��vq�r��1��LH����JH����JHǢ��M��.Y:u�@A6��-� .1A�[AT*H���<�T.���O����{2T&TM���	��o[WB{����v�������qK/(ں�x�Q��*�m�������/�
�uC��7T��AP��K.^Aa�b�o����AHB���g!�J̭���!�J����C((��*tHiq�}BӰƪ|t�����.^>��=Ƒ0���pO�ou�CP���yA���9/������|}A����0��b�n��҇Wo*�/����������5�TP��R�3C�7�i�sLE_���~"�?s�[��O�4�>��u�q%$l�
A�]7��Pt~C��}����j�.���&69��b�n�E������#���q'��ݹ�؝��<���jq�	��o(:���������
������?��я�X
����6%xr*�,����[�=��W%x�*荇�r�N������v}���t���{�WЃ:�Fo�1��J,�C��G�F,�C�y0o��s��(I���	)���Rz;��R��?�v�u%��2��3!��Zi�<�7t�����5t�:����^�		ci4��!�i}�gj����ٟg����w*�1��9��;�P�a>��g��2��3��Po�S:�������� -F�j      0   
  x�-�ˑ�0D��`�$r����cn(~j�Ǟ��'��_��� 
�(�t��[%�/�D)VG�QG�G���Q���j�m��^�@�4�e���o�n�BwAu���g�b�����T6˭ U�M5��a��-u*�Vo$ϴ@�QI
>�����HR�^u7���(9�����.�-�=J_�rm��Bl��mӋ�5�ѡ�vH����Ţ��h���Y�1ǎ���|̝��3����T��c�/�/gt����<��ifc      -   �
  x��Z�VW}_��b�[�V�K^�V^�a� ��Y0�02CȌ�"t1]���?��]un�-��C�M�S�]�����5skVf��3C�������ݮ5j�=]~5C�13K3��s3��]ҵ�BwG|}+ϓ��������4���ms�S�Z��EwW��+��p}$�g�nznf�6i�k�ϏѥG��3b�L���4�K��T`�0n�?�03��C�S�t�5�=>8�Z'L�zh^��
�@��G5sL?L��z�N`�µv��|��N����ʯ��歚���>�er|Y7������Y��م]u<��ֆ�|���HWf��e���rÙ`o�h}D�Wd��G7mwrx�"?l� ��G��x�"����'ب�I&A��ѝ����@���3�r^Pz��|@�z�X�c�J������?�0>Y�Ҍ�&i}��+����i�]����#�"�9��'�c$�'1�85��ե��͹�=���F�I_�s��*��r��L�T!P�Q5�m� s�,lnJ�XJ{x��K� ����<�/�kL�����8��������ao�4vOx/6B���_1�5ui�tq��ɿą��qi
,5}����%9�Fj��;��©��B	��#ρ���ԕ=�t3����f��Z�쇼�&>��tƕC�t���)�əq���U��?g�2>�Fi�UT!�D�qJ/�rs&G���'QDR��;��]�s���Xݲ'�s�k��rH�0}��o����{>�. }p�y�b
;^z��Ka����r!#��F�-��C������n
I�٧8�c��-�Uf�����h9���}M�8cnq�qH��3���������C~i�T��gi]vj�Ї�c �/-����C˟`��'���凧{����i;�ef#�q��Oh��?U0�{zK�%d���2`g��/Gj�R�O�{⥳�ԅN����3^!�\�3z���E<���"8�9�}U;�3pS��k�Ȍ%��#/d�QPA'\]t/0�� N��1�a��	;��*���|/���
��A�=�����[V��5�{��L��r�;펅U�S�nQR�UY��X��rȷ�G��ޫ�Z�RO}�AQ����X�����UVo�ɠJ�����h۟�ٷ@fPx= Z��@���.�O偓,+$WL�ְ>��=b�$ku.x��T��>�]��:f�����'!s�'�)/�ﳝRr��D�3�ː�W-R���L1yу���Mt
���bZA6�"M��+NQ�4�\pY��)�
}�л�����.S�1y���x9-��T�*��wB �������vq��tZ\yD8z�5�k/�fxØ�O[��
��8o�?��Y/?{6�Nti���gLA��=�<.Q��q��o�ME�˳f��:M�*aE���2���B}����~K���;:�T��w�'��	�2�OUz��D�!��o�����YB� 3���34�����|̚�g���4�2�B��6�iYHD��^��^�,ϷY�е�Z�v�>�zY�`C,���KENl�_{%�TR���X�̹YI�kBN�Z�$Oe%���z2 d�e�h�'X�(
X�p�O��!�4�Õ�a��r�4#�)�1h��QZn��͡�Z�$y�2�'��S-�ze"���إ�Xݷ�]��=�x��>������$M�7Ā��c�/���(���:.Ng�7R��k ��[K*�TD	�d-6n��B��jg��ad.97)E#�C�A���*�0� ��Ɋ���] K�����\��M�A!j�ơe�D*�q9�l�=�;��/����_0@�c���~�)�
��(�
�����h:�6.�%
�a�΢;���G��[�DX.(���3�X���`f�N
B�d�������9��l����BfK�v���P�$�����ц���7�����;c;�#/Š@�jEH�g�eۋo5r���M�5[¢rd�pV�N++����j�E�>L����"*�f�n���R�r��[��A<�l+*:�7I]yi��&��.HN�Y
C_獰)3T�a��N��(��T���|��D۽�A�{�À=o�ի(�t������2����P�?G��9&�@�'�U�����A���R���fb�Y�Ͻa4-��г\��C�O*���8vBZ\���<�
I�REz��������G,��ӝ��8����N7��u�i��-
R���|��/�9�Å��n�WU,���X�����X��ŋ�������I��ܓ<f�"�f��V���x�&�(}$A���L��T>�Zx��#�>^�%�ho4�dU��Z
4Y�������G��� mU H�4D��W���m���Y��)?�^z�\we����7�H,�����64����7{����5��x�R1�g̷6��	���2~<\�1kx����?��o���v����0~IݮD�UL���<]_	��(' Ӹ߬O8J�Ԓ�����~�<��0�:�e�O���,PU)0Ii�H�͏����挵���.��D�9<>��·k�n�hp��/be�
mM�zh8{����\�����z4񹋆0�] lrb,�;�<�I�o�)�iE?j�'lK�����O�nI<Ů�g�S&܃
�R�T)�i��e͂鿔Z��`����H��,��::����$ҁ��%�+ϵ���W�܈��#�h�m����p%1L|�70�n{kk��Bڰ'      7     x��X[n1���%�e��9A��ҋ��=��f���cr-Қ��#�G6I��wI���|}��ʵ�z��M�&�%�dB�)oI,�b�xx/|�\Orwi�׽R��W�z�Mz�Ym]z$��ԓD=�������������h\�&���<��*�,Zx4���A(�7q���q��>�@���MlX�''Ll���R2�.R�U��S6�<�ѥ6>vH�k��V��fbI��>�����[�[2iy;:ی�oP�t���_^l��Ø�l����c)D�������x�iKx��M���aRi��i�������]t��iC��v{��}Sw���߭���[���țgu�7��������y�AtT��L7�4�����(b��Y��%�����If.C�4����  [��.z����]<�4m����ymf�'q[Y���:_#��*����nR�����W2��`�z�g�͇�Se�%hƱ&9o>\Q��c�Z��`-���I�����Ǒ��5x��� � ?�L������`z�ImkW���my=Ϸ�C�p��;΍�U�S�2�
x�Wl��Ɓ�dzs��K(�#1��x̀�Xw�M2M%�e��N��뭷K�%�Q�{�"��Ұ��u	뵦�����>U�����#�����=XOn
4a��O��?ȿ�Ӓ�k�Q�����>]��+���z<t���w:����v�����MÏ��傽�7���~��o�[h��~�^�?T�O�     