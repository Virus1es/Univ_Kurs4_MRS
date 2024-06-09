-- ��� ������� ��� ��������

DROP VIEW IF EXISTS dbo.ViewInersWeakIncidents;
DROP VIEW IF EXISTS dbo.ViewEmployeesSienceTwo;
DROP VIEW IF EXISTS dbo.ViewIncidentsWithComment;
DROP VIEW IF EXISTS dbo.ViewEmployeesSurnameLikeA;
DROP VIEW IF EXISTS dbo.ViewEmployeesCommonAndcomandors;
GO  

-- ������ � ����������� (IN)
-- ������� �������������� � ���������� ������ �����������
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

-- ������ � ����������� (NOT IN)
-- ������� ���������� �� ������ � 2000
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

-- ������ � ����������� (Case)
-- ���� ������������ � ������� ����� ��� 500000 ������� "�������" ����� "�������"
create or alter view ViewIncidentsWithComment as
select
	Incidents.IncDate
	, Plots.Number
	, EmergencyCauses.CauseName
	, EmergencyTypes.TypeName
	, Incidents.Damage
	, (case when Incidents.Damage > 500000 then '�������' else '�������' end) as Comment
from
	Incidents join EmergencyCauses on Incidents.IdEmergencyCause = EmergencyCauses.Id
			  join EmergencyTypes on Incidents.IdEmergencyType = EmergencyTypes.Id
			  join Plots on Incidents.IdPlot = Plots.Id
go

 -- ������ � �������� �� �����
 -- ������� ���� ������� � ������ ������������ �� �
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
	Employees.FirstName like '�%';
go

-- ������ � ������������
-- ������� ����� � ��������� ������
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
		Positions.PositionName = '����'
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
		Positions.PositionName = '�������� ������') rez;
go

-- ������ ����� � � ��� �����
-- ������� ��������� � ����������� �� � �����
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

