select count(dataj->>'FirstName') from "Kurs"."JsonTable";

-- Отобразить всех рабочих с должностью боец
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
from 
	"Kurs"."JsonTable"
where
	dataj->'Position'->>'PositionName' = 'Боец';


-- Отобразить всех из определённого отделения
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
from 
	"Kurs"."JsonTable"
where
	dataj->'Department'->>'DepName' = 'Отважные';


-- Отобразить все отделения, год основания которых больше 1991
select DISTINCT
	dataj->'Department'->>'DepName' as "Name"
	, dataj->'Department'->>'YearCreation' as "Year"
from 
	"Kurs"."JsonTable"
where
	(dataj->'Department'->>'YearCreation')::int > 1991;


-- path
-- Вывести всех офицеров
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
from 
	"Kurs"."JsonTable"
where
	dataj@@'$.Position.PositionName!= "Боец"';


-- вывести рабочих с зарплатой до 40 000 
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
	, dataj->'Salary' as "Salary"
from 
	"Kurs"."JsonTable"
where
	dataj@@'$.Salary <= 40000';


-- вывести все отделения из определенного города
select DISTINCT
	dataj->'Department'->>'DepName' as "Name"
from 
	"Kurs"."JsonTable"
where
	dataj@@'$.Department.City.CityName == "Донецк"';

-- функций обработки
-- Информация о отделении определенного человека

declare @json nvarchar(max) = ( 
	FOR JSON PATH);

Select * from jsonb_populate_recordset(null::record, (
	select distinct
		jsonb_path_query_array(dataj, '$.Department')
	from 
		"Kurs"."JsonTable" 
	where
		dataj->>'FirstName' = 'Кирил' and 
		dataj->>'Surname' = 'Колбасов' and 
		dataj->>'Patronymic' = 'Петрович' 
)) as ("DepName" varchar, "City" jsonb, "Phone" varchar, "YearCreation" int)


-- Исключить значение null

select
	jsonb_strip_nulls(jsonb_path_query(dataj, '$.Department')) 
from 
	"Kurs"."JsonTable";


-- Донецкие отделения
select
	jsonb_each_text(jsonb_path_query(dataj, '$.Department'))
from 
	"Kurs"."JsonTable"
where
	dataj->'Department'->'City'->>'CityName' = 'Донецк';


-- Запросы на изменение и добавление
-- Изменение по имени
update 
	"Kurs"."JsonTable" 
set 
	dataj = jsonb_set(dataj, '{Position}', '{ "PositionName": "Генерал" }')
where 
	dataj->>'FirstName' = 'Кирил';


-- Добавление по фамилии
update 
	"Kurs"."JsonTable"  
set 
	dataj = jsonb_insert(dataj, '{age}', '35')
where 
	dataj->>'Surname' = 'Колбасов';

-- Добавление по фамилии
update 
	"Kurs"."JsonTable" 
set 
	dataj = jsonb_insert(dataj, '{Phone}', '"+79494012374"')
where 
	dataj->>'Surname' = 'Баранов';


-- Изменение по фамилии
update 
	"Kurs"."JsonTable" 
set 
	dataj = jsonb_set(dataj, '{Phone}', 'null')
where 
	dataj->>'Surname' = 'Баранов'
returning *;

-- Добавление
update 
	"Kurs"."JsonTable" 
set 
	dataj = dataj||'{"nation": "белорусс"}'
where 
	dataj->>'Surname' = 'Колбасов'
returning *;

-- Удаление ключа
update 
	"Kurs"."JsonTable" 
set 
	dataj = dataj-'nation'
where 
	dataj->>'Surname' = 'Колбасов'
returning *;


-- Удаление
delete from "Kurs"."JsonTable"
where dataj->>'Surname' = 'Колбасов';

delete from "Kurs"."JsonTable"
where dataj->>'FirstName' = 'Екатерина';

-- создание индексов
create index dataj_ind on "Kurs"."JsonTable"
	using GIN (dataj);
create index dataj_surname_ind on "Kurs"."JsonTable"
	using GIN ((dataj->'Surname'));
create index dataj_department_name_ind on "Kurs"."JsonTable"
	using GIN ((dataj->'Department'->'DepName'));

-- анлизы запросов

-- изначальный запрос
Explain(Analyze) 
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
from 
	"Kurs"."JsonTable"
where
	dataj->'Position'->>'PositionName' = 'Боец';

-- оптимизация
Explain(Analyze) 
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
from 
	"Kurs"."JsonTable"
where
	dataj@>'{"Position": { "PositionName": "Боец" }}';



-- изначальный запрос
Explain(Analyze) 
select
	jsonb_each_text(jsonb_path_query(dataj, '$.Department'))
from 
	"Kurs"."JsonTable"
where
	dataj->'Department'->'City'->>'CityName' = 'Донецк';

-- оптимизация
Explain(Analyze) 
select
	jsonb_each_text(jsonb_path_query(dataj, '$.Department'))
from 
	"Kurs"."JsonTable"
where
	dataj@>'{"Department.City.CityName": "Донецк"}';


-- изначальный запрос
Explain(Analyze)
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
from 
	"Kurs"."JsonTable"
where
	dataj->'Department'->>'DepName' = 'Отважные';

-- оптимизация
Explain(Analyze)
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
from 
	"Kurs"."JsonTable"
where
	dataj@>'{"Department.DepName": "Отважные"}';


-- изначальный запрос
Explain(Analyze)
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
	, dataj->'Salary' as "Salary"
from 
	"Kurs"."JsonTable"
where
	dataj@@'$.Salary <= 40000';


-- изначальный запрос
Explain(Analyze)
select 
	dataj->>'FirstName' as "FirstName"
	, dataj->>'Surname' as "Surname"
	, dataj->>'Patronymic' as "Patronymic"
	, dataj->'Position'->>'PositionName' as "Position"
	, dataj->>'YearStart' as "Year"
from 
	"Kurs"."JsonTable"
where
	(dataj->>'YearStart')::int > 2005;
