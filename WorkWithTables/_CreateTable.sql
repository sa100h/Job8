---- Словари

-- Должности
CREATE TABLE ranks
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__ranks__id 
		PRIMARY KEY (id)
);

-- Статусы заяки
CREATE TABLE statuses
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	color_class CHARACTER VARYING(20) NOT NULL,
	
	CONSTRAINT pk__statuses__id 
		PRIMARY KEY (id)
);

-- Категории пассажиров
CREATE TABLE categories
(
	id SERIAL ,
	code CHARACTER VARYING(3) NOT NULL,
	name CHARACTER VARYING(50) NOT NULL,
	description CHARACTER VARYING(100) NULL,
	
	CONSTRAINT pk__categories__id 
		PRIMARY KEY (id)
);

-- Участки
CREATE TABLE areas
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__areas__id PRIMARY KEY (id)
);

-- Смены
CREATE TABLE shifts
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__shifts__id 
		PRIMARY KEY (id)
);

-- Методы приема заявки
CREATE TABLE acceptance_methods
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__acceptance_methods__id 
		PRIMARY KEY (id)
);

-- Линии метро
CREATE TABLE lines
(
    id SERIAL,
    name CHARACTER VARYING(100),
	color_hex CHARACTER VARYING(7),
	
	CONSTRAINT pk__lines__id 
		PRIMARY KEY (id)
);

--Станции метро
CREATE TABLE stations
(
    id SERIAL,
    name  CHARACTER VARYING(100),
	
	CONSTRAINT pk__stations__id 
		PRIMARY KEY (id)
);

-- Линии со станциями метро
CREATE TABLE station_lines
(
	station_id INTEGER,
	line_id INTEGER,
	
	CONSTRAINT pk__station_lines__station_id__line_id 
		PRIMARY KEY (station_id,line_id),
	CONSTRAINT fk__station_lines__stations__station_id__id 
		FOREIGN KEY (station_id) 
		REFERENCES stations (id),
	CONSTRAINT fk__station_lines__lines__line_id__id 
		FOREIGN KEY (line_id) 
		REFERENCES lines (id)
	
);

-- Время движения между станциями
CREATE TABLE travel_times
(
	st1_id INTEGER NOT NULL,
	st2_id  INTEGER NOT NULL,
	time time NOT NULL,

	CONSTRAINT pk__travel__st1_id__st2_id 
		PRIMARY KEY (st1_id,st2_id),
	CONSTRAINT fk__travel__stantions__st1_id__id 
		FOREIGN KEY (st1_id) 
		REFERENCES stations (id),
	CONSTRAINT fk__travel__stantions__st2_id__id 
		FOREIGN KEY (st2_id) 
		REFERENCES stations (id)
);

-- Время перехода между станциями
CREATE TABLE transfer_times
(
	st1_id INTEGER NOT NULL,
	st2_id INTEGER NOT NULL,
	time time NOT NULL,

	CONSTRAINT pk__transfer__st1_id__st2_id 
		PRIMARY KEY (st1_id,st2_id),
	CONSTRAINT fk__transfer__stantions__st1_id__id 
		FOREIGN KEY (st1_id) 
		REFERENCES stations (id),
	CONSTRAINT fk__transfer__stantions__st2_id__id 
		FOREIGN KEY (st2_id) 
		REFERENCES stations (id)
);


----------------------------------------------------------------------------------------------------------
---- Обычные таблицы

--Пользователи
CREATE TABLE users
(
	id SERIAL,
	login CHARACTER VARYING(50) NOT NULL,
	password CHARACTER VARYING(50) NOT NULL,
	last_name CHARACTER VARYING(20) NOT NULL,
	first_name CHARACTER VARYING(20) NOT NULL,
	middle_name CHARACTER VARYING(20),
	
	CONSTRAINT pk__users__id 
		PRIMARY KEY (id)
);

--Роли
CREATE TABLE roles
(
	id SERIAL,
	name CHARACTER VARYING(50) NOT NULL,
  
	CONSTRAINT pk__roles__id 
		PRIMARY KEY (id)
);

-- Роли у пользоателей
CREATE TABLE user_roles
(
	user_id INTEGER NOT NULL,
	role_id INTEGER NOT NULL,

	CONSTRAINT pk__user_roles__user_id__role_id 
		PRIMARY KEY (user_id,role_id),
	CONSTRAINT fk__user_roles__users__user_id__id 
		FOREIGN KEY (user_id) 
		REFERENCES users (id),
	CONSTRAINT fk__user_roles__roles__role_id__id 
		FOREIGN KEY (role_id) 
		REFERENCES roles (id)
);

-- Токены
CREATE TABLE tokens
(
	id SERIAL,
	create_time timestamp NOT NULL DEFAULT now(),
	date_end timestamp NOT NULL,
	user_id INTEGER NOT NULL,
	token CHARACTER VARYING(128) NOT NULL,
	
	CONSTRAINT pk__tokens__id 
		PRIMARY KEY (id),
	CONSTRAINT fk__tokens__users__user_id__id 
		FOREIGN KEY (user_id) 
		REFERENCES roles (id)
);


-- Сотрудник
CREATE TABLE employees
(
	user_id INTEGER ,
	personnel_number CHARACTER VARYING(8) NOT NULL,
	is_male bit NOT NULL,
	person_phone CHARACTER VARYING(12) NOT NULL,

	CONSTRAINT pk__employees__user_id 
		PRIMARY KEY (user_id),	
	CONSTRAINT fk__employees__users__user_id__id 
		FOREIGN KEY (user_id) 
		REFERENCES users (id)
);

-- Работа (режим) сотрудника
CREATE TABLE employee_works
(
	id SERIAL ,
	employee_id INTEGER NOT NULL,
	rank_id INTEGER NOT NULL,
	shift_id  INTEGER NOT NULL,
	area_id  INTEGER NOT NULL,
	work_phone CHARACTER VARYING(12) NOT NULL,
	start_time time NOT NULL,
	end_time time NOT NULL,
	only_light_work bit NOT NULL,

	CONSTRAINT pk__employee_works__id 
		PRIMARY KEY (id),
	CONSTRAINT fk__employee_works__employees__employee_id__user_id 
		FOREIGN KEY (employee_id) 
		REFERENCES employees (user_id),
	CONSTRAINT fk__employee_works__ranks__rank_id__id 
		FOREIGN KEY (rank_id) 
		REFERENCES ranks (id),
	CONSTRAINT fk__employee_works__shifts__shift_id__user_id 
		FOREIGN KEY (shift_id) 
		REFERENCES shifts (id),
	CONSTRAINT fk__employee_works__areas__area_id__user_id 
		FOREIGN KEY (area_id) 
		REFERENCES areas (id)
);

-- Рабочий день
CREATE TABLE working_days
(
	Id SERIAL ,
	employee_work_id INTEGER NOT NULL,
	shift_date date NOT NULL,
	is_additional_day bit NOT NULL,
	start_time time NOT NULL,
	end_time time NOT NULL,
	is_other_work_time bit NOT NULL,

	CONSTRAINT pk__working_days__id 
		PRIMARY KEY (id),
	CONSTRAINT fk__working_days__employee_works__employee_work_id__id 
		FOREIGN KEY (employee_work_id) 
		REFERENCES employee_works (id)
);

-- Пассажир
CREATE TABLE passengers
(
	id SERIAL ,
	last_name CHARACTER VARYING(20) NOT NULL,
	first_name CHARACTER VARYING(20) NOT NULL,
	middle_name CHARACTER VARYING(20),
	is_male bit NOT NULL,
	category_id INTEGER NOT NULL,
	is_EKS bit NOT NULL,
	phone_info  CHARACTER VARYING(1000) NULL,
	add_info CHARACTER VARYING(1000) NULL,

	CONSTRAINT pk__passengers__id 
		PRIMARY KEY (id),	
	CONSTRAINT fk__employees__categories__create_user_id__id 
		FOREIGN KEY (category_id) 
		REFERENCES categories (id)
);

-- Заявка
CREATE TABLE bids
(
	id SERIAL ,
	pas_id INTEGER NOT NULL,
	count_pass INTEGER NOT NULL,
	category_id INTEGER NOT NULL,
	baggage_type CHARACTER VARYING(50) NULL,
	baggage_weight CHARACTER VARYING(50) NULL,
	is_need_help bit NOT NULL,
	st_beg_id INTEGER NOT NULL,
	st_beg_desc CHARACTER VARYING(150) NULL,
	st_end_id INTEGER NOT NULL,
	st_end_desc CHARACTER VARYING(150) NULL,
	start_time timestamp NOT NULL,
	meeting_time time NULL,
	completion_time time NULL,
	status_id INTEGER NOT NULL,
	number_all INTEGER NOT NULL,
	number_sex_m INTEGER NOT NULL,
	number_sex_f INTEGER NOT NULL,
	execution_time time NOT NULL,
	acceptance_method_id INTEGER NOT NULL,

	CONSTRAINT pk__bids__id 
		PRIMARY KEY (id),	
	CONSTRAINT fk__bids__passengers__pas_id__id 
		FOREIGN KEY (pas_id) 
		REFERENCES passengers (id),
	CONSTRAINT fk__bids__categories__create_user_id__id 
		FOREIGN KEY (category_id) 
		REFERENCES categories (id),
	CONSTRAINT fk__bids__stations__st_beg_id__id 
		FOREIGN KEY (st_beg_id) 
		REFERENCES stations (id),
	CONSTRAINT fk__bids__stations__st_end_id__id 
		FOREIGN KEY (st_end_id) 
		REFERENCES stations (id),
	CONSTRAINT fk__bids__statuses__status_id__id 
		FOREIGN KEY (status_id) 
		REFERENCES statuses (id),
	CONSTRAINT fk__bids__acceptance_methods__acceptance_method_id__id 
		FOREIGN KEY (acceptance_method_id) 
		REFERENCES acceptance_methods (id)

);

-- Сотрудники на заявках
CREATE TABLE employee_on_bids
(
	bid_id INTEGER NOT NULL,
	employee_work_id INTEGER NOT NULL,
	is_automatic bit NOT NULL,
	
	CONSTRAINT pk__employee_on_bids__bid_id__employee_id 
		PRIMARY KEY (bid_id, employee_work_id),	
	CONSTRAINT fk__employee_on_bids__bids__bid_id__id 
		FOREIGN KEY (bid_id) 
		REFERENCES bids (id),
	CONSTRAINT fk__employee_on_bids__employee_works__employee_work_id__id 
		FOREIGN KEY (employee_work_id) 
		REFERENCES employee_works (id)
);



----------------------------------------------------------------------------------------------------------
----- Работа с операциями

-- Таблицы
CREATE TABLE tables
(
	id INTEGER NOT NULL,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__tables__id 
		PRIMARY KEY (id),
	CONSTRAINT uq__operations__name 
		UNIQUE (name)
);

-- Тип операции
CREATE TABLE operation_types
(
	id SERIAL ,
	name CHARACTER VARYING(50) NOT NULL,
	
	CONSTRAINT pk__operation_types__id 
		PRIMARY KEY (id),
	CONSTRAINT uq__operation_types__name 
		UNIQUE (name)
);

-- Операции
CREATE TABLE operations
(
	id SERIAL ,
	table_id INTEGER NOT NULL,
	oper_type_id INTEGER NOT NULL,
	edit_id INTEGER NOT NULL,
	edit_value jsonb NOT NULL,
	
	edit_time timestamp NOT NULL DEFAULT now(),
  	edit_user_id INTEGER NOT NULL,
	
	CONSTRAINT pk__operations__id 
		PRIMARY KEY (id),
	CONSTRAINT fk__operations__tabls__table_id__id 
		FOREIGN KEY (table_id) 
		REFERENCES tables (id),
	CONSTRAINT fk__operations__operation_types__oper_type_id__id 
		FOREIGN KEY (oper_type_id) 
		REFERENCES operation_types (id),
	CONSTRAINT fk__operations__users__edit_user_id__id 
		FOREIGN KEY (edit_user_id) 
		REFERENCES users (id)
);
