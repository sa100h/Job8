-- Станции со всеми линиями
CREATE OR REPLACE  VIEW station_with_line AS
	SELECT 
		  s.id as station_id
		, s.name as station_name
		, STRING_AGG(l.name, ', ') as line_name
		, min(l.color_hex::text) AS color_hex
	FROM stations s
	INNER JOIN station_lines sl
		ON sl.station_id = s.id
	INNER JOIN lines l
		ON l.id = sl.line_id
	group by s.id, s.name 
	order by 1;
	

-- Информация о пассажире в главной форме 
CREATE OR REPLACE VIEW form_main_passenger AS
	SELECT 
		  p.id as pas_id
		, last_name as last_name
		, first_name as first_name
		, middle_name as middle_name
		, phone_info as phone_info
		, case
			when is_male = 1::bit then 'М'
			else 'Ж'
		end as sex
		, c.code as category_code
		, is_EKS as is_EKS
		, add_info as add_info
	FROM passengers p
	INNER JOIN categories c
		on c.id = category_id;



-- Информация о заявке в главной форме 
CREATE OR REPLACE VIEW form_main_bid AS
	with
	  bids_with_employees as
	(
		SELECT 
			  eb.bid_id as bid_id
			, get_name(u.last_name, u.first_name, u.middle_name) as employee_name
		FROM employee_on_bids eb
		left join employee_works ew
			ON ew.id = eb.employee_work_id
		left join users u
			ON u.id = ew.employee_id
	)
	, bids_with_group_employees as
	(
		select 
			bid_id
			, STRING_AGG(employee_name, ', ') AS employees
		from bids_with_employees
		GROUP BY bid_id
	)
	, bids_all as
	(
		SELECT 
			  b.id as number
			, b.start_time as start_time
			, get_name(p.last_name, p.first_name, p.middle_name) as passenger
			, bge.employees as employees
			, s.name as status
		FROM bids b
		INNER JOIN passengers p
			ON p.id = pas_id
		INNER JOIN statuses s
			ON s.id = status_id
		left join bids_with_group_employees bge
			ON bge.bid_id = b.id
	)
	select
		*
	from bids_all;




-- Информация о заявке в форме Просмотра
CREATE OR REPLACE VIEW form_view_bid AS
	with
	  bids_with_employees as
	(
		SELECT 
			  eb.bid_id as bid_id
			, get_name(u.last_name, u.first_name, u.middle_name) as employee_name
		FROM employee_on_bids eb
		left join employee_works ew
			ON ew.id = eb.employee_work_id
		left join users u
			ON u.id = ew.employee_id
	)
	, bids_with_group_employees as
	(
		select 
			bid_id
			, STRING_AGG(employee_name, ', ') AS employees
		from bids_with_employees
		GROUP BY bid_id
	)
	, bids_all as
	(
		SELECT 
			  b.id as number
			, s.name as status
		
			, mp.last_name as pas_last_name
			, mp.first_name as pas_first_name
			, mp.middle_name as pas_middle_name
			, mp.sex as pas_sex
			, mp.phone_info as pas_phone_info
			, mp.category_code as pas_category_code
			, mp.is_EKS as pas_is_EKS
			, mp.add_info as pas_add_info
		
			, b.count_pass as count_pass
			, c.code as category_code
			, b.baggage_type as baggage_type
			, b.baggage_weight as baggage_weight
			, b.is_need_help as is_need_help
		
			, b.start_time as start_time
			, st_beg_id as st_beg_id
			, st_beg_desc as st_beg_desc
			, st_end_id as st_end_id
			, st_end_desc as st_end_desc

			, b.number_all as number_all 
			, b.number_sex_m as number_sex_m
			, b.number_sex_f as number_sex_f
			
			, bge.employees as employees

			, am.name as acceptance_method
		FROM bids b
		INNER JOIN form_main_passenger mp
			ON mp.pas_id = b.pas_id
		INNER JOIN statuses s
			ON s.id = status_id
		INNER JOIN categories c
			ON c.id = category_id
		INNER JOIN acceptance_methods am
			ON am.id = acceptance_method_id
		left join bids_with_group_employees bge
			ON bge.bid_id = b.id
	)
	select
		*
	from bids_all;


	


-- Информация о пользователях с ролями в главной форме 
CREATE OR REPLACE VIEW form_main_user_and_role AS
	with
	emp_last_work as
	(
		select 
			  employee_id as employee_id
			, max(id) as id
		from employee_works
		group by employee_id
	)
	SELECT 
		  u.id as user_id
		, get_name(u.last_name, u.first_name, u.middle_name) as user_name
		, login as login
		, password as password
		, ra.name as rank_name
		, ro.name as role_name
	FROM users u
	INNER JOIN user_roles ur
		on ur.user_id = u.id
	INNER JOIN roles ro
		on ro.id = ur.role_id
	LEFT JOIN employees e
		on e.user_id = u.id
	LEFT JOIN emp_last_work elw
		ON elw.employee_id = e.user_id
	LEFT JOIN employee_works ew
		ON ew.id = elw.id
	LEFT JOIN ranks ra
		on ra.id = ew.rank_id;






-- Информация о пользователях с ролями в  форме просмотра 
CREATE OR REPLACE VIEW form_view_user_and_role AS
	with
	emp_last_work as
	(
		select 
			  employee_id as employee_id
			, max(id) as id
		from employee_works
		group by employee_id
	)
	SELECT 
		  u.id as user_id
		, login as login
		, password as password
		, u.last_name as last_name
		, u.first_name as first_name
		, u.middle_name as middle_name
		, ro.name as role_name
		
		, ra.name as rank_name
		, e.is_male as is_male
		, ew.work_phone as work_phone
		, e.person_phone as person_phone
		, s.name as shift_name
		, ew.start_time as start_time
		, ew.end_time as end_time
		, e.personnel_number as personnel_number
		, ew.only_light_work as only_light_work
	FROM users u
	INNER JOIN user_roles ur
		on ur.user_id = u.id
	INNER JOIN roles ro
		on ro.id = ur.role_id
	LEFT JOIN employees e
		on e.user_id = u.id
	LEFT JOIN emp_last_work elw
		ON elw.employee_id = e.user_id
	LEFT JOIN employee_works ew
		ON ew.id = elw.id
	LEFT JOIN ranks ra
		on ra.id = ew.rank_id
	LEFT JOIN shifts s
		ON s.id = ew.shift_id;


-- Информация о сотрудниках в  форме заявки
CREATE OR REPLACE VIEW form_select_employee_in_bid AS
	with
	emp_last_work as
	(
		select 
			  employee_id as employee_id
			, max(id) as id
		from employee_works
		group by employee_id
	)
	SELECT 
		  ew.id as id
		, u.last_name as last_name
		, u.first_name as first_name
		, u.middle_name as middle_name
		, a.name as area_name 
		, e.personnel_number as personnel_number
	FROM users u
	INNER JOIN user_roles ur
		on ur.user_id = u.id
	INNER JOIN roles ro
		on ro.id = ur.role_id
	LEFT JOIN employees e
		on e.user_id = u.id
	LEFT JOIN emp_last_work elw
		ON elw.employee_id = e.user_id
	LEFT JOIN employee_works ew
		ON ew.id = elw.id
	LEFT JOIN areas a
		ON a.id = ew.area_id
		
		
		
		
-- Рабочий день сотрудника

CREATE OR REPLACE VIEW public.working_day_employees
 AS
 SELECT wd.id,
    wd.employee_work_id,
    e.is_male,
    wd.shift_date + wd.start_time AS start_time,
        CASE
            WHEN wd.end_time < wd.start_time THEN wd.shift_date + wd.end_time + '1 day'::interval
            ELSE wd.shift_date + wd.end_time
        END AS end_time,
	wd.lunch_start as lunch_start,
	wd.lunch_end as lunch_end 
   FROM working_days wd
     JOIN employee_works ew ON ew.id = wd.employee_work_id
     JOIN employees e ON e.user_id = ew.employee_id;

ALTER TABLE public.working_day_employees
    OWNER TO postgres;

