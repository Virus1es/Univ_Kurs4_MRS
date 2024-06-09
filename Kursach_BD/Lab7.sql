select count(json_value(dataj, '$.FirstName')) from JsonTable; go

-- ������� �������

-- ���������� ���� ������� � ���������� ����
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') = '����';
go

-- ���������� ���� �� ������������ ���������
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
	, json_value(dataj, '$.Position.PositionName') as Position
from 
	JsonTable
where
	json_value(dataj, '$.Department.DepName') = '��������';
go

-- ���������� ��� ���������, ��� ��������� ������� ������ 1991
select DISTINCT
	json_value(dataj, '$.Department.DepName') as [Name]
	, json_value(dataj, '$.Department.YearCreation') as [Year]
from 
	JsonTable
where
	json_value(dataj, '$.Department.YearCreation') > 1991;
go

-- path
-- ������� ���� ��������
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
	, json_value(dataj, '$.Position.PositionName') as Position
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') != '����';
go

-- ������� ������� � ��������� �� 40 000 �� 70 000
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

-- ������� ��� ��������� �� ������������� ������
select DISTINCT
	json_value(dataj, '$.Department.DepName') as [Name]
from 
	JsonTable
where
	json_value(dataj, '$.Department.City.CityName') = '������';
go

-- ������� ���������
-- ���������� � ��������� ������������� ��������

declare @json nvarchar(max) = (select
		json_query(dataj, '$.Department') as Department
	from 
		JsonTable 
	where
		json_value(dataj, '$.FirstName') = '����' and 
		json_value(dataj, '$.Surname') = '������' and 
		json_value(dataj, '$.Patronymic') = '����������' 
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


-- ��������� �������� null
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

-- �������� ���������
declare @json nvarchar(max) = (
	select distinct json_query(dataj, '$.Department') as Department from JsonTable FOR JSON PATH);

select
	value
from 
	OPENJSON(@json)
where
	json_value(value, '$.Department.City.CityName') = '������'
;
go

-- ������� �� ��������� � ����������
-- ��������� �� �����
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Department.City', '{ "CityName": "��������" }')
where 
	json_value(dataj, '$.FirstName') = '�����';
go

-- ���������� �� �������
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.age', '35')
where 
	json_value(dataj, '$.Surname') = '������';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = '������';
go

-- ���������� �� �������
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Phone', '+79494012374')
where 
	json_value(dataj, '$.Surname') = '�������';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = '�������';
go

-- ��������� �� �������
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.Salary', '80000')
where 
	json_value(dataj, '$.Surname') = '������';
go

-- ����������
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.nation', '��������')
where 
	json_value(dataj, '$.Surname') = '������';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = '������';
go

-- �������� �����
update 
	JsonTable 
set 
	dataj = JSON_MODIFY(dataj, '$.nation', null)
where 
	json_value(dataj, '$.Surname') = '������';
go

select *
from 
	JsonTable
where
	json_value(dataj, '$.Surname') = '������';
go

-- ��������
delete from JsonTable
where json_value(dataj, '$.Surname') = '������';

delete from JsonTable
where json_value(dataj, '$.FirstName') = '�������';

-- �������� ��������
create index dataj_ind on dbo.JsonTable(dataj);
create index dataj_surname_ind on dbo.JsonTable(json_value(dataj, '$.Surname'));
create index dataj_department_name_ind on dbo.JsonTable(json_value(dataj, '$.Department.DepName'));

-- ������ ��������

-- ����������� ������
SET SHOWPLAN_ALL oFF;  
GO 
select 
	json_value(dataj, '$.FirstName') as [Name]
	, json_value(dataj, '$.Surname') as Surname
	, json_value(dataj, '$.Patronymic') as Patronymic
from 
	JsonTable
where
	json_value(dataj, '$.Position.PositionName') = '����';
go

-- ����� �������� �������

-- �����������