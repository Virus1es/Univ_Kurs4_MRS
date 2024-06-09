use Kursach_BD;
go


DROP VIEW IF EXISTS dbo.ViewCountEmergenciesByType;  
DROP VIEW IF EXISTS dbo.ViewCountIncidentsByMinDamage;  
GO  


-- Сложные запросы
-- Лабораторная работа №6

-- Итоговый без условия
-- Количество чрезвычайных ситуаций по типам и всего
create or alter view ViewCountEmergenciesByType with schemabinding as
select
	EmergencyTypes.TypeName
	, count(Incidents.IdEmergencyType) as Amount
from
	dbo.Incidents join dbo.EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
group by
	EmergencyTypes.TypeName;
go

--create index indx on Incidents(IdEmergencyType);
--drop index indx on Incidents;

-- Итоговый с условием на данные
-- Количество ЧС по датам с ущербом на сумму больше указанной
---------------------------------------------------------------------
create or alter proc SelectGroupIncidentsByDamage
	@SelectSum int
as
select
	Incidents.IncDate
	, count(Incidents.Id) as Amount
from
	Incidents
where
	Incidents.Damage > @SelectSum
group by
	Incidents.IncDate;
go

-- Итоговый с условием на группы
-- Участки с суммарным ущербом за всё время больше указанного
create or alter proc SelectGroupPlotsByDamage
	@SelectSum int
as
select
	Plots.Number
	, Mines.MineName
	, sum(Incidents.Damage) as SumDamage
from
	Incidents join (Plots join Mines on Plots.IdMine = Mines.Id)
					on Incidents.IdPlot = Plots.Id
group by
	Plots.Number
	, Mines.MineName
having
	sum(Incidents.Damage) > @SelectSum;
go

-- Итоговый с условием на группы и данные
-- Участки, где суммарный ущерб больше указанного за определённый промежуток времени 
create or alter proc SelectGroupPlotsByDamageAndRangeDate
	@SelectSum int,
	@StartDate date,
	@FinishDate date
as
select
	Mines.MineName
	, Plots.Number
	, sum(Incidents.Damage) as SumDamage
from
	Incidents join (Plots join Mines on Plots.IdMine = Mines.Id)
					on Incidents.IdPlot = Plots.Id
where
	Incidents.IncDate between @StartDate and @FinishDate
group by
	Plots.Number
	, Mines.MineName
having
	sum(Incidents.Damage) > @SelectSum;
go

-- Запрос на запросе по принципу итогового запроса
-- Количетсво ЧС с минимальным ущербом для каждой шахты
---------------------------------------------------------------------
create or alter view ViewCountIncidentsByMinDamage with schemabinding as
select
	Mines.MineName
	, count(*) as IncidentsCount
from
	dbo.Incidents right join (dbo.Plots join dbo.Mines on Plots.IdMine = Mines.Id)
						on Incidents.IdPlot = Plots.Id
where
	Incidents.Damage = (select min(Incs.Damage) as MinDamage from dbo.Incidents Incs)
group by
	Mines.MineName;
go

-- Запрос с подзапросом
-- Шахты находящиеся в определённом городе
create or alter proc SelectMinesByCity
	@SelectCity nvarchar(50)
as
select
	Mines.MineName
from
	Mines
where
	(Mines.Id in (select Mines.Id
				  from Mines join Cities on Mines.IdCity = Cities.Id
				  where Cities.CityName = @SelectCity));
go
