use Kursach_BD;
go

-- удаление представлений для перестройки базы
DROP VIEW IF EXISTS dbo.ViewEmployees;
DROP VIEW IF EXISTS dbo.ViewIncidents;
DROP VIEW IF EXISTS dbo.ViewIncidentIners;
DROP VIEW IF EXISTS dbo.ViewEmergencyTypesWithoutIncidents;
DROP VIEW IF EXISTS dbo.ViewEmployeesWithoutIncidents;
GO  

-- Простые запросы
-- Лабораторная работа №5

-- симметричное внутреннее соединение с условием (по дате)
-- выбирает ЧС случившиеся в выбранную дату
create or alter proc SelectIncidentsByDate
	@SelectDate date
as
	select
		Incidents.IncDate
		, EmergencyTypes.TypeName
		, EmergencyCauses.CauseName
		, Mines.MineName
		, Plots.Number
		, Incidents.Damage
	from
		Incidents join EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
				  join EmergencyCauses on Incidents.IdEmergencyCause = EmergencyCauses.Id
				  join (Plots join Mines on Plots.IdMine = Mines.Id) on Incidents.IdPlot = Plots.Id
	where
		IncDate = @SelectDate;
go

-- симметричное внутреннее соединение с условием (по дате)
-- выбирает работников устраняющих ЧС в выбранную дату
create or alter proc SelectIncidentInersByDate
	@SelectDate date
as
	select
		Employees.Surname + ' ' + SUBSTRING(Employees.FirstName,1,1) + '.' + 
				SUBSTRING(Employees.Patronymic,1,1) + '.'  as EmployeeFullname
		, Incidents.IncDate
		, EmergencyTypes.TypeName
		, Mines.MineName
		, Plots.Number
		, IncidentIners.DaysAmount
	from
		IncidentIners join (Incidents join EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
									  join (Plots join Mines on Plots.IdMine = Mines.Id) on Incidents.IdPlot = Plots.Id)
							on IncidentIners.IdIncident = Incidents.Id
					  join Employees on IncidentIners.IdEmployee = Employees.Id
	where
		IncDate = @SelectDate;
go
exec SelectIncidentInersByDate '2022-10-11';
go

-- симметричное внутреннее соединение с условием (по внешнему ключу)
-- участки находящиеся в выбранной шахте
create or alter proc SelectPlotsByMine
	@SelectMine nvarchar(50)
as
	select
		Plots.Id
		, Plots.Number
		, Plots.LengthPlot
		, ProductionTypes.TypeName as ProductionType
		, CoalTypes.TypeName as CoalType
		, Plots.YearStart
		, Mines.MineName
	from 
		Plots join Mines on Plots.IdMine = Mines.Id
			  join ProductionTypes on Plots.IdProductionType = ProductionTypes.Id
			  join CoalTypes on Plots.IdCoalType = CoalTypes.Id
	where
		Mines.MineName = @SelectMine;
go

-- симметричное внутреннее соединение с условием (по внешнему ключу)
-- рабочие принадлежащие выбранному отделению
create or alter proc SelectEmployeesByDepartment
	@SelectDepartment nvarchar(50)
as
	select
		Employees.Id
		, Employees.Surname
		, Employees.FirstName
		, Employees.Patronymic
		, Employees.Salary
		, Employees.YearStart
		, Employees.Birthday
		, Positions.PositionName
		, Departments.DepName
	from 
		Employees join Positions on Employees.IdPosition = Positions.Id
				  join Departments on Employees.IdDepartment = Departments.Id
	where
		Departments.DepName = @SelectDepartment;
go

-- симметричные внутренние соединения без условия (представления)
-- рабочие
create or alter view ViewEmployees with schemabinding as
select
	Employees.Id
	, Employees.Surname
	, Employees.FirstName
	, Employees.Patronymic
	, Employees.Salary
	, Employees.YearStart
	, Employees.Birthday
	, Positions.PositionName 
	, Departments.DepName
	from 
		dbo.Employees join dbo.Positions on Employees.IdPosition = Positions.Id
					  join dbo.Departments on Employees.IdDepartment = Departments.Id;
go

-- чрезвычайные случаи
create or alter view ViewIncidents with schemabinding as
select
	Incidents.Id
	, Incidents.IncDate
	, EmergencyTypes.TypeName
	, EmergencyCauses.CauseName
	, Mines.MineName
	, Plots.Number
	, Incidents.Damage
from
	dbo.Incidents join dbo.EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
				  join dbo.EmergencyCauses on Incidents.IdEmergencyCause = EmergencyCauses.Id
				  join (dbo.Plots join dbo.Mines on Plots.IdMine = Mines.Id) 
						on Incidents.IdPlot = Plots.Id;
go

-- участники устранений последствий ЧС
create or alter view ViewIncidentIners with schemabinding as
select
	IncidentIners.Id
	, Employees.Surname + ' ' + SUBSTRING(Employees.FirstName,1,1) + '.' + 
			SUBSTRING(Employees.Patronymic,1,1) + '.'  as EmployeeFullname
	, Incidents.IncDate
	, EmergencyTypes.TypeName
	, Mines.MineName
	, Plots.Number
	, IncidentIners.DaysAmount
from
	dbo.IncidentIners join (dbo.Incidents join dbo.EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
										  join (dbo.Plots join dbo.Mines on Plots.IdMine = Mines.Id) 
												on Incidents.IdPlot = Plots.Id)
							on IncidentIners.IdIncident = Incidents.Id
					  join dbo.Employees on IncidentIners.IdEmployee = Employees.Id;
go

-- левое внешнее соединение
-- типы ЧС по которым нет ни одного случая
create or alter view ViewEmergencyTypesWithoutIncidents with schemabinding as
select
	EmergencyTypes.TypeName
from
	dbo.EmergencyTypes left outer join dbo.Incidents on EmergencyTypes.Id = Incidents.IdEmergencyType
where
	Incidents.Id is null;
go

-- правое внешнее соединение
-- рабочие не участвовавшие в устранениях ЧС
create or alter view ViewEmployeesWithoutIncidents with schemabinding as
select
	Employees.Surname
	, Employees.FirstName
	, Employees.Patronymic
	, Positions.PositionName
	, Departments.DepName
from
	dbo.IncidentIners right outer join (dbo.Employees join dbo.Positions on Employees.IdPosition = Positions.Id
													  join dbo.Departments on Employees.IdDepartment = Departments.Id)
										 on IncidentIners.IdEmployee = Employees.Id
where
	IncidentIners.Id is null;
go

-- запрос на запросе по принципу левого соединения
-- рабочие, которые не участвовали в устранениях ЧС в определённую дату
create or alter proc SelectEmployeesWithoutInsByDate
	@SelectDate date
as
	select
		Employees.Surname
		, Employees.FirstName
		, Employees.Patronymic
		, Positions.PositionName
		, Departments.DepName
	from 
		Employees left join (select 
								IncidentIners.IdEmployee
								, IncidentIners.Id as IncInId
							from
								IncidentIners join Incidents on IncidentIners.IdIncident = Incidents.Id
							where
								Incidents.IncDate = @SelectDate) ins
								on ins.IdEmployee = Employees.Id
				  join Positions on Employees.IdPosition = Positions.Id
				  join Departments on Employees.IdDepartment = Departments.Id
	where
		ins.IncInId is null;
go