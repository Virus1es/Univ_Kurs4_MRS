select count(json_value(dataj, '$.FirstName')) from JsonTable; go

-- Простые запросы

-- Отобразить всех рабочих с должностью боец
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') = 'Боец';
go

-- Отобразить всех из определённого отделения
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
	, json_value(dataj, '$.Position.PositionName') as Position
from 
	JsonTable
where
	json_value(dataj, '$.Department.DepName') = 'Отважные';
go

-- Отобразить все отделения, год основания которых больше 1991
select DISTINCT
	json_value(dataj, '$.Department.DepName') as [Name]
	, json_value(dataj, '$.Department.YearCreation') as [Year]
from 
	JsonTable
where
	json_value(dataj, '$.Department.YearCreation') > 1991;
go

-- path
-- Вывести всех офицеров
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
	, json_value(dataj, '$.Position.PositionName') as Position
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') != 'Боец';
go

-- вывести рабочих с зарплатой от 40 000 до 70 000
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
	, json_value(dataj, '$.Position.PositionName') as Position
	, json_value(dataj, '$.Salary') as Salary
from 
	JsonTable
where
	json_value(dataj, '$.Salary') between 40000 and 70000;
go

-- вывести все отделения из определенного города
select DISTINCT
	json_value(dataj, '$.Department.DepName') as [Name]
from 
	JsonTable
where
	json_value(dataj, '$.Department.City.CityName') = 'Донецк';
go

-- функций обработки
-- Информация о отделении определенного человека

declare @json nvarchar(max) = (select
		json_query(dataj, '$.Department') as Department
	from 
		JsonTable 
	where
		json_value(dataj, '$.FirstName') = 'Анна' and 
		json_value(dataj, '$.Surname') = 'Ушкало' and 
		json_value(dataj, '$.Patronymic') = 'Степановна' 
	FOR JSON PATH);

Select 
	DepName
	, City
	, Phone
	, YearCreation
from 
	OPENJSON(@json) 
with 
	(DepName NVARCHAR(50) '$.Department.DepName',
     City NVARCHAR(50) '$.Department.City.CityName',
	 Phone NVARCHAR(50) '$.Department.Phone',
	 YearCreation NVARCHAR(50) '$.Department.YearCreation') ;
go


-- Исключить значение null
declare @json nvarchar(max) = (
	select isnull(json_query(dataj, '$.Department'), '') as Department from JsonTable FOR JSON PATH);

select
	DepName
	, City
	, Phone
	, YearCreation
from 
	OPENJSON(@json) 
with 
	(DepName NVARCHAR(50) '$.Department.DepName',
     City NVARCHAR(50) '$.Department.City.CityName',
	 Phone NVARCHAR(50) '$.Department.Phone',
	 YearCreation NVARCHAR(50) '$.Department.YearCreation') ;
go

-- Донецкие отделения
declare @json nvarchar(max) = (
	select distinct json_query(dataj, '$.Department') as Department from JsonTable FOR JSON PATH);

select
	value
from 
	OPENJSON(@json)
where
	json_value(value, '$.Department.City.CityName') = 'Донецк'
;
go

-- Запросы на изменение и добавление
-- Изменение по имени
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Department.City', '{ "CityName": "Макеевка" }')
where 
	json_value(dataj, '$.FirstName') = 'Павел';
go

-- Добавление по фамилии
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.age', '35')
where 
	json_value(dataj, '$.Surname') = 'Ушкало';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = 'Ушкало';
go

-- Добавление по фамилии
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Phone', '+79494012374')
where 
	json_value(dataj, '$.Surname') = 'Баранов';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = 'Баранов';
go

-- Изменение по фамилии
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Salary', '80000')
where 
	json_value(dataj, '$.Surname') = 'Ушкало';
go

-- Добавление
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.nation', 'белорусс')
where 
	json_value(dataj, '$.Surname') = 'Ушкало';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = 'Ушкало';
go

-- Удаление ключа
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.nation', null)
where 
	json_value(dataj, '$.Surname') = 'Ушкало';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = 'Ушкало';
go

-- Удаление
delete from JsonTable
where json_value(dataj, '$.Surname') = 'Ушкало';

delete from JsonTable
where json_value(dataj, '$.FirstName') = 'Дмитрий';

-- создание индексов
create index dataj_ind on dbo.JsonTable(dataj);
create index dataj_surname_ind on dbo.JsonTable(json_value(dataj, '$.Surname'));
create index dataj_department_name_ind on dbo.JsonTable(json_value(dataj, '$.Department.DepName'));

-- анлизы запросов

-- изначальный запрос
SET SHOWPLAN_ALL oFF;  
GO 
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') = 'Боец';
go

-- после создания индекса

-- оптимизация