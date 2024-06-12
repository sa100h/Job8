-- Станции со всеми линиями
CREATE OR REPLACE  VIEW station_with_line AS
	SELECT 
		  s.id as station_id
		, s.name as station_name
		, STRING_AGG(l.name, ', ') as line_name
	FROM stations s
	INNER JOIN station_lines sl
		ON sl.station_id = s.id
	INNER JOIN lines l
		ON l.id = sl.line_id
	group by s.id, s.name 
	order by 1
	

-- Информация о пассажире в главной форме 
CREATE OR REPLACE VIEW main_passenger AS
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
		on c.id = category_id



-- Информация о заявке в главной форме 
CREATE OR REPLACE VIEW main_bid AS
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
	from bids_all



-- Информация о заявке в форме редактирования/Просмотра
CREATE OR REPLACE VIEW form_edit_bid AS
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
	from bids_all


