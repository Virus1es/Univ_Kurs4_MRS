-- Доп запросы для курсавой

DROP VIEW IF EXISTS dbo.ViewInersWeakIncidents;
DROP VIEW IF EXISTS dbo.ViewEmployeesSienceTwo;
DROP VIEW IF EXISTS dbo.ViewIncidentsWithComment;
DROP VIEW IF EXISTS dbo.ViewEmployeesSurnameLikeA;
DROP VIEW IF EXISTS dbo.ViewEmployeesCommonAndcomandors;
GO  

-- запрос с подзапросом (IN)
-- рабочие учавствовавшие в устранении слабых проишествий
create or alter view ViewInersWeakIncidents as
(select distinct
	Employees.FirstName
	, Employees.Surname
	, Employees.Patronymic
	, Departments.DepName
	, Positions.PositionName
from
	IncidentIners join (Employees join Positions on Employees.IdPosition = Positions.Id
								  join Departments on Employees.IdDepartment = Departments.Id)
						on IncidentIners.IdEmployee = Employees.Id
				  join Incidents on IncidentIners.IdIncident = Incidents.Id
where
	IncidentIners.IdIncident in (select Id from Incidents where Incidents.Damage < 100000));
go

-- запрос с подзапросом (NOT IN)
-- рабочие вступившие на службу с 2000
create or alter view ViewEmployeesSienceTwo as
select distinct
	Employees.FirstName
	, Employees.Surname
	, Employees.Patronymic
	, Departments.DepName
	, Positions.PositionName
	, Employees.YearStart
from
	Employees join Positions on Employees.IdPosition = Positions.Id
			  join Departments on Employees.IdDepartment = Departments.Id
where
	Employees.Id not in (select Id from Employees where Employees.YearStart < 2000);
go

-- запрос с подзапросом (Case)
-- если происшествие с ущербом более чем 500000 вывести "Сильное" иначе "Обычное"
create or alter view ViewIncidentsWithComment as
select
	Incidents.IncDate
	, Plots.Number
	, EmergencyCauses.CauseName
	, EmergencyTypes.TypeName
	, Incidents.Damage
	, (case when Incidents.Damage > 500000 then 'Сильное' else 'Обычное' end) as Comment
from
	Incidents join EmergencyCauses on Incidents.IdEmergencyCause = EmergencyCauses.Id
			  join EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
			  join Plots on Incidents.IdPlot = Plots.Id
go

 -- запрос с условием по маске
 -- выбрать всех рабочих с именем начинающимся на А
create or alter view ViewEmployeesSurnameLikeA as
select
	Employees.FirstName
	, Employees.Surname
	, Employees.Patronymic
	, Departments.DepName
	, Positions.PositionName
from
	Employees join Positions on Employees.IdPosition = Positions.Id
			  join Departments on Employees.IdDepartment = Departments.Id
where 
	Employees.FirstName like 'А%';
go

-- запрос с объедтнением
-- рабочие бойцы и командиры взвода
create or alter view ViewEmployeesCommonAndcomandors as
select 
	rez.Fullname
	, rez.DepName
	, rez.PositionName
from (
	select
		Employees.FirstName + ' ' + SUBSTRING(Employees.Surname,1,1) 
		+ '.' + SUBSTRING(Employees.Patronymic,1,1) + '.' as Fullname
		, Departments.DepName
		, Positions.PositionName
	from
		Employees join Positions on Employees.IdPosition = Positions.Id
				  join Departments on Employees.IdDepartment = Departments.Id
	where 
		Positions.PositionName = 'Боец'
	union
	select
		Employees.FirstName + ' ' + SUBSTRING(Employees.Surname,1,1) + '.' 
		+ SUBSTRING(Employees.Patronymic,1,1) + '.' as Fullname
		, Departments.DepName
		, Positions.PositionName
	from
		Employees join Positions on Employees.IdPosition = Positions.Id
				  join Departments on Employees.IdDepartment = Departments.Id
	where 
		Positions.PositionName = 'Командир взвода') rez;
go

-- запрос всего и в том числе
-- участие отделений в устранениях ЧП и всего
create or alter proc CountDepIners as
select distinct
	Departments.DepName
	, count(*) as Amount
from
	IncidentIners join (Employees join Positions on Employees.IdPosition = Positions.Id
								  join Departments on Employees.IdDepartment = Departments.Id)
						on IncidentIners.IdEmployee = Employees.Id
				  join Incidents on IncidentIners.IdIncident = Incidents.Id
group by GROUPING sets (Departments.DepName, ())
order by (Departments.DepName);
go

