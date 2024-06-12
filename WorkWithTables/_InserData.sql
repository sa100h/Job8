----- Добавление в Работа с операциями

---ДОБАВЛЯЕМ в Таблицы
INSERT INTO public.tables( id, name) VALUES 
(101,'tables'),
(102,'operation_types'),
(103,'operations'),
(104,'ranks'),
(105,'statuses'),
(106,'categories'),
(107,'areas'),
(108,'shifts'),
(109,'acceptance_methods'),
(110,'lines'),
(111,'stations'),
(112,'station_lines'),
(113,'travel_times'),
(114,'transfer_times'),
(201,'users'),
(202,'roles'),
(203,'user_roles'),
(204,'tokens'),
(205,'employees'),
(206,'employee_works'),
(207,'working_days'),
(208,'passengers'),
(209,'bids'),
(210,'employee_on_bids');


---ДОБАВЛЯЕМ в Типы операций
INSERT INTO public.operation_types( id, name) VALUES 
(1,'Создание'),
(2,'Редактирование'),
(3,'Удаление');

SELECT nextVal('"public"."operation_types_id_seq"');
SELECT setVal(	'"public"."operation_types_id_seq"',
				(select max("id") FROM public."operation_types"));

---- Добавление в словари таблицы

---ДОБАВЛЯЕМ Должности
INSERT INTO public.ranks( id, name, create_time, create_user_id) VALUES 
(1,'ЦУ'),
(2,'ЦСИ'),
(3,'ЦИ');

SELECT nextVal('"public"."ranks_id_seq"');
SELECT setVal(	'"public"."ranks_id_seq"',
				(select max("id") FROM public."ranks"));
--Администратор, Специалист, Оператор??
		

---ДОБАВЛЯЕМ Статусы
INSERT INTO public.statuses( id, name, create_time, create_user_id) VALUES 
(1,'Не подтверждена'),
(2,'В рассмотрении'),
(3,'Принята'),
(4,'Инспектор выехал'),
(5,'Инспектор на месте'),
(6,'Поездка'),
(7,'Заявка закончена'),
(8,'Выявление'),
(9,'Лист Ожидания'),
(10,'Отмена'),
(11,'Отказ'),
(12,'Пассажир опаздывает'),
(13,'Инспектор опаздывает');

SELECT nextVal('"public"."statuses_id_seq"');
SELECT setVal(	'"public"."statuses_id_seq"',
				(select max("id") FROM public."statuses"));
	
---ДОБАВЛЯЕМ категории пассажиров
INSERT INTO public.passenger_categories( id,code, name, description, create_time, create_user_id) VALUES 
(1, 'ИЗТ', 'Инвалид по зрению', 'тотальный, сопровождение по метрополитену'),
(2, 'ИЗ', 'Инвалид по зрению с остаточным зрением', 'слабовидящий, сопровождение по метрополитену'),
(3, 'ИС', 'Инвалид по слуху', 'в основном помощь в ориентировании'),
(4, 'ИК', 'Инвалид колясочник', 'передвижение в инвалидной коляске'),
(5, 'ИО', 'Инвалид опорник', 'необходима поддержка при передвижении и/или на лестницах/эскалаторах'),
(6, 'ДИ', 'Ребенок инвалид ', 'зачастую передвижение в инвалидной коляске'),
(7, 'ПЛ', 'Пожилой человек', 'необходима поддержка при передвижении и/или на лестницах/эскалаторах'),
(8, 'РД', 'Родители с детьми', 'сопровождение ребенка'),
(9, 'РДК', 'Родители с детскими колясками', 'помощь с детской коляской'),
(10, 'ОГД', 'Организованные группы детей', 'сопровождение по метрополитену'),
(11, 'ОВ', 'Временно маломобильные', 'после операции, переломы и прочее'),
(12, 'ИУ', 'Люди с ментальной инвалидностью', NULL);
SELECT nextVal('"public"."passenger_categories_id_seq"');
SELECT setVal(	'"public"."passenger_categories_id_seq"',
				(select max("id") FROM public."passenger_categories"));

---ДОБАВЛЯЕМ Медоды приема
INSERT INTO public.acceptance_methods(id, name) VALUES 
	(1, 'Телефон'),
	(2, 'E-mail');

SELECT nextVal('"public"."acceptance_methods_id_seq"');
SELECT setVal(	'"public"."acceptance_methods_id_seq"',
				(select max("id") FROM public."acceptance_methods"));
				
---ДОБАВЛЯЕМ Участки
INSERT INTO public.areas( id, name) VALUES 
(1,'ЦУ-1'),
(2,'ЦУ-2'),
(3,'ЦУ-3'),
(4,'ЦУ-3(Н)'),
(5,'ЦУ-4'),
(6,'ЦУ-4(Н)'),
(7,'ЦУ-5'),
(8,'ЦУ-8');


SELECT nextVal('"public"."areas_id_seq"');
SELECT setVal(	'"public"."areas_id_seq"',
				(select max("id") FROM public."areas"));

---ДОБАВЛЯЕМ в Типы операций
INSERT INTO public.operation_types( id, name) VALUES 
(1,'Создание'),
(2,'Редактирование'),
(3,'Удаление');


SELECT nextVal('"public"."operation_types_id_seq"');
SELECT setVal(	'"public"."operation_types_id_seq"',
				(select max("id") FROM public."operation_types"));
				
---ДОБАВЛЯЕМ Смены
INSERT INTO public.shifts( id, name, create_time, create_user_id) VALUES 
(1,'1'),
(2,'2'),
(3,'1(Н)'),
(4,'2(Н)'),
(5,'5');

SELECT nextVal('"public"."shifts_id_seq"');
SELECT setVal(	'"public"."shifts_id_seq"',
				(select max("id") FROM public."shifts"));

	
---ДОБАВЛЯЕМ Линии метро
insert into public.lines(id, name) VALUES
(1,'1'),
(2,'2'),
(3,'3'),
(4,'4'),
(20,'4А'),
(5,'5'),
(6,'6'),
(7,'7'),
(8,'8'),
(21,'8А'),
(9,'9'),
(10,'10'),
(11,'БКЛ'),
(22,'БКЛ(А)'),
(12,'Л1'),
(14,'14'),
(15,'15'),
(16,'Д1'),
(17,'Д2'),
(18,'Д3'),
(19,'Д4');

SELECT nextVal('"public"."lines_id_seq"');
SELECT setVal(	'"public"."lines_id_seq"',
				(select max("id") FROM public."lines"));
				
				
---ДОБАВЛЯЕМ станции метро
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/Metro.json';
	FROM 'D:\1\Git\JsonForTables\Metro.json';

with 
t1 as
(
	SELECT 
		 cast(data->>'id' as integer) as id
		 ,data->>'name_station'  as name
	FROM temp_json_data_table
)

insert into public.stations(id, name)
select DISTINCT
	t1.id
	, t1.name
from t1
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;

SELECT nextVal('"public"."stations_id_seq"');
SELECT setVal(	'"public"."stations_id_seq"',
				(select max("id") FROM public."stations"));


				
---ДОБАВЛЯЕМ связи между станции метро и линией
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/Metro.json';
	FROM 'D:\1\Git\JsonForTables\Metro.json';

with 
t1 as
(
	SELECT 
		 cast(data->>'id' as integer) as station_id
		 ,data->>'name_line'  as line_name
	FROM temp_json_data_table
)

insert into public.station_lines(station_id, line_id)
select DISTINCT
	station_id
	, l.id as line_id
from t1
inner join lines l
	on l.name = t1.line_name
order by 1,2;

DROP TABLE IF EXISTS temp_json_data_table;






---ДОБАВЛЯЕМ переходы между станциями метро
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/Transfer.json';
	FROM 'D:\1\Git\JsonForTables\Transfer.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'id1' as integer) as st1_id
		, cast(data->>'id2' as integer) as st2_id
		, cast(replace(data->>'time',',','.') as numeric(5,2)) as time1
		
	FROM temp_json_data_table
)

insert into public.transfer_times(st1_id,st2_id, time)
select DISTINCT
	  st1_id
	, st2_id
	, '00:00:00'::time +  (TRUNC(time1) * 60+ round((time1-TRUNC(time1))*100,0) ) * INTERVAL '1 second' as time
from t1
order by st1_id,st2_id;

DROP TABLE IF EXISTS temp_json_data_table;



---ДОБАВЛЯЕМ время движения между станциями метро
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/Travel.json';
	FROM 'D:\1\Git\JsonForTables\Travel.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'id_st1' as integer) as st1_id
		, cast(data->>'id_st2' as integer) as st2_id
		, cast(replace(data->>'time',',','.') as numeric(5,2)) as time1
		
	FROM temp_json_data_table
)

insert into public.travel_times(st1_id,st2_id, time)
select DISTINCT
	  st1_id
	, st2_id
	, '00:00:00'::time +  (TRUNC(time1) * 60+ round((time1-TRUNC(time1))*100,0) ) * INTERVAL '1 second' as time
from t1
order by st1_id	, st2_id;

DROP TABLE IF EXISTS temp_json_data_table;





---- Добавление в обычные таблицы

---ДОБАВЛЯЕМ РОЛИ
INSERT INTO public.roles(id,name) VALUES 
(1,'Администратор'),
(2,'Специалист'),
(3,'Оператор'),
(4,'Сотрудник сопровождения');

SELECT nextVal('"public"."roles_id_seq"');
SELECT setVal(	'"public"."roles_id_seq"',
				(select max("id") FROM public."roles"));
				
---ДОБАВЛЯЕМ АДМИНА
INSERT INTO public.users(id,login, password, last_name, first_name, middle_name) VALUES 
(1,'admin','-', 'Админов','Админ', 'Админович');

SELECT nextVal('"public"."users_id_seq"');
SELECT setVal(	'"public"."users_id_seq"',
				(select max("id") FROM public."users"));
				
---ДОБАВЛЯЕМ РОЛЬ Администратора - АДМИНУ
INSERT INTO public.user_roles(user_id, role_id) VALUES 
(1, 1);



---ДОБАВЛЯЕМ ПОЛЬЗОВАТЕЛЕЙ 
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/EMP.json';
	FROM 'D:\1\Git\JsonForTables\EMP.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'ID' as INTEGER) as id
		, data->>'FIO' as name
		, case
				when (data->>'SEX') = 'Мужской' then 1
				when (data->>'SEX') = 'Женский' then 0
				else 2
			end as isMale
		, '00000000' as personnel_number
		, cast('01.01.2000 00:00:00' as timestamp) as create_time
		, 1 as create_user_id
	FROM temp_json_data_table
)

insert into public.users(id,login, password,  last_name,first_name,middle_name)
select DISTINCT
	id, name,name,name,name,name 
from t1
order by 1;


DROP TABLE IF EXISTS temp_json_data_table;

SELECT nextVal('"public"."users_id_seq"');
SELECT setVal(	'"public"."users_id_seq"',
				(select max("id") FROM public."users"));
		
---ДОБАВЛЯЕМ РОЛИ ДЛЯ СОТРУДНИКОВ КАК КАК Сотрудник сопровождения
insert into public.user_roles(user_id, role_id)
select
	id as user_id,4 as role_id
from public.users
where id > 1;



---ДОБАВЛЯЕМ СОТРУДНИКОВ
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/EMP.json';
	FROM 'D:\1\Git\JsonForTables\EMP.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'ID' as INTEGER) as id
		, case
				when (data->>'SEX') = 'Мужской' then 1
				when (data->>'SEX') = 'Женский' then 0
			end as is_male
		, '00000000' as personnel_number
	FROM temp_json_data_table
)

insert into public.employees(user_id, personnel_number, is_male, person_phone)
select DISTINCT
	id as user_id,personnel_number,  CAST(is_male AS bit),'+71234567890' as person_phone
from t1
order by 1;


DROP TABLE IF EXISTS temp_json_data_table;

				
				
---ДОБАВЛЯЕМ РАБОТУ ДЛЯ СОТРУДНИКОВ
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/EMP.json';
	FROM 'D:\1\Git\JsonForTables\EMP.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'ID' as INTEGER) as id
		, data->>'RANK'  as rank_name
		, data->>'SMENA'as shift_name
		, data->>'UCHASTOK' as uchastok
		, '+74993231212' as work_phone
		, cast(split_part(data->>'TIME_WORK','-', 1) as time) start_time
		, cast(split_part(data->>'TIME_WORK','-', 2) as time) end_time
		, cast(0 as bit) as only_light_work
		, *
	FROM temp_json_data_table
)

insert into public.employee_works(id, employee_id, rank_id, shift_id, area_id, work_phone, start_time, end_time, only_light_work)
select DISTINCT
	t1.id as id, t1.id as employee_id
	, r.id as rank_id
	, s.id as shift_id
	, a.id as area_id
	, work_phone, start_time, end_time, only_light_work
from t1
inner join ranks r
	ON replace(r.name,' ','') = replace(t1.rank_name,' ','')
	
left join shifts s
	ON replace(replace(replace(s.name,' ',''),'(',''),')','') =replace(replace(replace(t1.shift_name,' ',''),'(',''),')','') 
left join areas a
	ON replace(a.name,' ','') =replace(t1.uchastok,' ','') 
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;

SELECT nextVal('"public"."employee_works_id_seq"');
SELECT setVal(	'"public"."employee_works_id_seq"',
				(select max("id") FROM public."employee_works"));
							
				
				
				
				
---ДОБАВЛЯЕМ Рабочий день
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/EMP.json';
	FROM 'D:\1\Git\JsonForTables\EMP.json';


with 
t1 as
(
	SELECT 
		  cast(data->>'ID' as INTEGER) as employee_work_id
		, TO_TIMESTAMP(data->>'DATE', 'DD.MM.YYYY')    as shift_date
		, (0::bit) as is_additional_day
		, cast(split_part(data->>'TIME_WORK','-', 1) as time) start_time
		, cast(split_part(data->>'TIME_WORK','-', 2) as time) end_time
		, (0::bit) as is_other_work_time
		, *
	FROM temp_json_data_table
)
insert into public.working_days(employee_work_id, shift_date, is_additional_day, start_time, end_time, is_other_work_time)
select distinct
	  employee_work_id
	, shift_date
	, is_additional_day
	, start_time
	, end_time
	, is_other_work_time

from t1
	order by 2,1;


DROP TABLE IF EXISTS temp_json_data_table;



---ДОБАВЛЯЕМ Пассажиров
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/BID.json';
	FROM 'D:\1\Git\JsonForTables\BID.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'id_pas' as integer) as id
		, 'Фамилия ' || (data->>'id_pas') as last_name
		, 'Имя ' || (data->>'id_pas') as first_name
		, 'Отчество ' || (data->>'id_pas') as middle_name
		, 1::bit as is_male 
		, data->>'cat_pas' as category
		, null as add_info
		, 0 :: bit as is_eks
		, *  
	FROM temp_json_data_table
)
, t2 as
(
	select DISTINCT
		id,last_name, first_name, middle_name, is_male
		, min(category) as category, add_info, is_eks
	from t1
	group by id, last_name, first_name, middle_name, is_male
		, add_info, is_eks
)
	
insert into public.passengers(id, last_name, first_name, middle_name, is_male, category_id, add_info, is_eks)
select DISTINCT
	t2.id,last_name, first_name, middle_name, is_male
	,c.id as category_id, add_info, is_eks
from t2
left join categories c
	on c.code = t2.category
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;

SELECT nextVal('"public"."passengers_id_seq"');
SELECT setVal(	'"public"."passengers_id_seq"',
				(select max("id")  FROM public."passengers"));





---ДОБАВЛЯЕМ Заявки
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/BID.json';
	FROM 'D:\1\Git\JsonForTables\BID.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'id' as integer) as id
		, cast(data->>'id_pas' as integer) as pas_id
		, cast(data->>'id_st1' as integer) as st_beg_id
		, cast(data->>'id_st2' as integer) as st_end_id
	    , TO_TIMESTAMP(data->>'datetime', 'DD.MM.YYYY HH24:MI:SS') as start_time
		, cast(data->>'time3' as time) as meeting_time
		, cast(data->>'time3' as time) as completion_time
		, data->>'cat_pas' as category
		, replace(replace(replace(data->>'status','Отмена заявки по просьбе пассажира','Отмена'),'Отмена заявки по неявке пассажира','Отмена'),'Отказ по регламенту','Отказ') as status
		, cast(data->>'INSP_SEX_M' as INTEGER) as number_sex_m
		, cast(data->>'INSP_SEX_F' as INTEGER) as number_sex_f
		, cast(data->>'TIME_OVER' as time)as execution_time
	FROM temp_json_data_table
)

insert into public.bids(id, pas_id, count_pass, is_need_help, st_beg_id, st_end_id, start_time
	, meeting_time, completion_time, category_id, status_id, number_all, number_sex_m, number_sex_f
	, execution_time, acceptance_method_id)
select DISTINCT
	t1.id, pas_id, 1 as count_pass, 0::bit as is_need_help, st_beg_id, st_end_id, start_time
	, meeting_time, completion_time
	, c.id as category_id
	, s.id as status_id
	, number_sex_m + number_sex_f as number_all, number_sex_m, number_sex_f
	, execution_time, 1 as acceptance_method_id

from t1
left join categories c
	on c.code = t1.category

left join statuses s
	on s.name = t1.status
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;

SELECT nextVal('"public"."bids_id_seq"');
SELECT setVal(	'"public"."bids_id_seq"',
				(select max("id")  FROM public."bids"));









---- не нужно




---ДОБАВЛЯЕМ Отмененные заявки
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/Cancel.json';
	FROM 'D:\1\Git\JsonForTables\Cancel.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'ID_BID' as integer) as bid_id
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as cancellation_time
	
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as create_time
		, 1 as create_user_id
		, *  
	FROM temp_json_data_table
)

insert into public.bid_cancellations(bid_id, cancellation_time, create_time, create_user_id)
select DISTINCT
	bid_id, cancellation_time
	, create_time, create_user_id

from t1
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;



---ДОБАВЛЯЕМ Пассажир не явился
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/NoShow.json';
	FROM 'D:\1\Git\JsonForTables\NoShow.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'ID_BID' as integer) as bid_id
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as withdrawal_time
	
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as create_time
		, 1 as create_user_id
		, *  
	FROM temp_json_data_table
)

insert into public.bid_pass_noshows(bid_id, withdrawal_time, create_time, create_user_id)
select DISTINCT
	bid_id, withdrawal_time
	, create_time, create_user_id

from t1
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;


---ДОБАВЛЯЕМ Переносы заявок 
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/NoShow.json';
	FROM 'D:\1\Git\JsonForTables\NoShow.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'ID_BID' as integer) as bid_id
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as cancellation_time
	
		, TO_TIMESTAMP(data->>'DATE_TIME', 'DD.MM.YYYY HH24:MI:SS')as create_time
		, 1 as create_user_id
		, *  
	FROM temp_json_data_table
)

insert into public.bid_pass_noshows(bid_id, withdrawal_time, create_time, create_user_id)
select DISTINCT
	bid_id, cancellation_time
	, create_time, create_user_id

from t1
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;



---ДОБАВЛЯЕМ Переносы заявок 
DROP TABLE IF EXISTS temp_json_data_table;
CREATE TEMPORARY TABLE temp_json_data_table (
  data jsonb
);

copy temp_json_data_table(data)
--	FROM '/home/api/files/PostPo.json';
	FROM 'D:\1\Git\JsonForTables\PostPo.json';

with 
t1 as
(
	SELECT 
		  cast(data->>'id_bid' as integer) as bid_id
		, TO_TIMESTAMP(data->>'time_edit', 'DD.MM.YYYY HH24:MI:SS')as modification_time
		, cast(data->>'time_s' as time )as initial_time
		, cast(data->>'time_f' as time )as requested_time
	
		, TO_TIMESTAMP(data->>'time_edit', 'DD.MM.YYYY HH24:MI:SS')as create_time
		, 1 as create_user_id
		, *  
	FROM temp_json_data_table
)

insert into public.bid_postponements( bid_id, modification_time, initial_time
	, requested_time, create_time, create_user_id)
select DISTINCT
	bid_id, modification_time, initial_time
	, requested_time, create_time, create_user_id
from t1
order by 1;

DROP TABLE IF EXISTS temp_json_data_table;