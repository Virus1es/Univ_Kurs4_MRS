set noexec off
go

use master 
go

-- ��� ���������� �� ������� ��
if db_id('Kursach_BD') is null
begin
	create database Kursach_BD on (
	    name = Kursach_BD, 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Kursach_BD.mdf'
	)
	log on (
		name = Kursach_BD_log, 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Kursach_BD_log.ldf'
	);
end
else begin
print '�� ��� ���� �� �������'
end;
go

use Kursach_BD;
go

-- �������� ������������ ��������� ������
begin transaction;
print '';
print '�������� ������������ ������:';
print '';

-- ������� ������ ������� ������� IncidentIners(������� � ��������� ��)
if OBJECT_ID('IncidentIners') is not null begin
	drop table IncidentIners;
	print '������� ������� IncidentIners';
end;

-- ������� ������ ������� ������� Incidents(������������ ������������ �� ��������)
if OBJECT_ID('Incidents') is not null begin
	drop table Incidents;
	print '������� ������� Incidents';
end;

-- ������� ������ ������� ������� Employees(����������)
if OBJECT_ID('Employees') is not null begin
	drop table Employees;
	print '������� ������� Employees';
end;

-- ������� ������ ������� ������� Users(������������)
if OBJECT_ID('Users') is not null begin
	drop table Users;
	print '������� ������� Users';
end;

-- ������� ������ ������� ������� Departments(���������)
if OBJECT_ID('Departments') is not null begin
	drop table Departments;
	print '������� ������� Departments';
end;

-- ������� ������ ������� ������� Plots(�������)
if OBJECT_ID('Plots') is not null begin
	drop table Plots;
	print '������� ������� Plots';
end;

-- ������� ������ ������� ������� Mines(�����)
if OBJECT_ID('Mines') is not null begin
	drop table Mines;
	print '������� ������� Mines';
end;

-- ������� ������ ������� ������� Cities(������)
if OBJECT_ID('Cities') is not null begin
	drop table Cities;
	print '������� ������� Cities';
end;

-- ������� ������ ������� ������� Positions(���������)
if OBJECT_ID('Positions') is not null begin
	drop table Positions;
	print '������� ������� Positions';
end;

-- ������� ������ ������� ������� ProductionTypes(���� ���������)
if OBJECT_ID('ProductionTypes') is not null begin
	drop table ProductionTypes;
	print '������� ������� ProductionTypes';
end;

-- ������� ������ ������� ������� CoalTypes(���� ����)
if OBJECT_ID('CoalTypes') is not null begin
	drop table CoalTypes;
	print '������� ������� CoalTypes';
end;

-- ������� ������ ������� ������� EmergencyTypes(���� ��)
if OBJECT_ID('EmergencyTypes') is not null begin
	drop table EmergencyTypes;
	print '������� ������� EmergencyTypes';
end;

-- ������� ������ ������� ������� EmergencyCauses(������� ��)
if OBJECT_ID('EmergencyCauses') is not null begin
	drop table EmergencyCauses;
	print '������� ������� EmergencyCauses';
end;

-- ������� ������ ������� ������� JsonTable(������� Json �� �7)
if OBJECT_ID('JsonTable') is not null begin
	drop table JsonTable;
	print '������� ������� JsonTable';
end;


-- ���� �������� ���� �� ���� �������, ��������
-- ����������
if object_id('Users') is not null  or 
   object_id('JsonTable') is not null  or 
   object_id('Cities') is not null  or 
   object_id('Positions') is not null or
   object_id('ProductionTypes') is not null or
   object_id('CoalTypes') is not null or
   object_id('EmergencyTypes') is not null or
   object_id('EmergencyCauses') is not null or
   object_id('Plots') is not null or
   object_id('Mines') is not null or
   object_id('Departments') is not null or
   object_id('Employees') is not null or
   object_id('IncidentIners') is not null or
   object_id('Incidents') is not null begin  
   rollback transaction
   
   print ''
   print '�� ��� ������� �������'
   print ''

   set noexec on;
end else begin
   commit transaction;
   
   print ''
   print '�������� ������ ���������'
   print ''
end;


begin transaction

-- �������� ������� ������ Json
create table JsonTable (
	 Id    int  not null identity(1, 1),  -- ��� ��������������
	 dataj nvarchar(max) null,            -- �������� json

	 constraint JsonTable_PK primary key (Id)
);
go

-- �������� ������� ������
create table Cities (
     Id       int          not null identity(1, 1),  -- ��� ��������������
	 CityName nvarchar(50) not null,                 -- �������� ������
	 
	 constraint Cities_PK primary key (Id)
);
go


-- �������� ������� ���������
create table Positions (
     Id           int          not null identity(1, 1),  -- ��� ��������������
	 PositionName nvarchar(50) not null,                 -- �������� ���������
	 
	 constraint Positions_PK primary key (Id)
);
go


-- �������� ������� ���� ���������
create table ProductionTypes (
     Id       int          not null identity(1, 1),  -- ��� ��������������
	 TypeName nvarchar(50) not null,                 -- �������� ���� ���������
	 
	 constraint ProductionTypes_PK primary key (Id)
);
go


-- �������� ������� ���� ����
create table CoalTypes (
     Id       int          not null identity(1, 1),  -- ��� ��������������
	 TypeName nvarchar(50) not null,                 -- �������� ���� ����
	 
	 constraint CoalTypes_PK primary key (Id)
);
go


-- �������� ������� ���� ��
create table EmergencyTypes (
     Id       int          not null identity(1, 1),  -- ��� ��������������
	 TypeName nvarchar(50) not null,                 -- �������� ���� ��
	 
	 constraint EmergencyTypess_PK primary key (Id)
);
go


-- �������� ������� ������� ��
create table EmergencyCauses (
     Id       int          not null identity(1, 1),  -- ��� ��������������
	 CauseName nvarchar(50) not null,                 -- �������� ������� ��
	 
	 constraint EmergencyCauses_PK primary key (Id)
);
go


-- �������� ������� �����
create table Mines (
     Id         int          not null identity(1, 1) constraint Mines_PK primary key (Id),
	 MineName   nvarchar(50) not null,                 -- �������� �����
	 IdCity     int          not null,                 -- �����
	 MaxDepth   int          not null,                 -- ������������ �������
	 Area       int          not null,                 -- ������� ���������

	 constraint Mines_MaxDepth_check check (MaxDepth > 0),
	 constraint Mines_Area_check check (Area > 0),
	 -- ����� � �������� ������
	 constraint FK_Mines_Cities foreign key(IdCity) references dbo.Cities(Id)
)WITH
(
    DATA_COMPRESSION = NONE ON PARTITIONS (MineName)
);
go


-- �������� ������� �������
create table Plots (
     Id               int          not null identity(1, 1) constraint Plots_PK primary key (Id),
	 Number           nvarchar(20) not null,                 -- �������-��������� ����� �������
	 LengthPlot       int          not null,                 -- ����� �������
	 IdProductionType int          not null,                 -- ��� ���������
	 IdCoalType       int          not null,                 -- ��� ����
	 YearStart        int          not null,                 -- ��� ����� � ��������
	 IdMine           int          not null,                 -- ����� � ������� ���������� �������
	 
	 constraint Plots_YearStart_check check (YearStart between 1800 and Year(getdate())),
	 -- ����� � �������� ���� ���������
	 constraint FK_Plots_ProductionTypes foreign key(IdProductionType) references dbo.ProductionTypes(Id),
	 -- ����� � �������� ���� ����
	 constraint FK_Plots_CoalTypes foreign key(IdCoalType) references dbo.CoalTypes(Id),
	 -- ����� � �������� �����
	 constraint FK_Plots_Mines foreign key(IdMine) references dbo.Mines(Id)
);
go

-- �������� ������� ��������� ���
create table Departments (
     Id           int          not null identity(1, 1) constraint Departments_PK primary key (Id),
	 DepName      nvarchar(50) not null,                 -- �������� ���������
	 IdCity       int          not null,                 -- �����
	 Phone        nvarchar(30) not null,                 -- �������
	 YearCreation int          not null,                 -- ��� ��������
	 
	 constraint Departments_YearCreation_check check (YearCreation between 1800 and Year(getdate())),
	 -- ����� � �������� ������
	 constraint FK_Departments_Cities foreign key(IdCity) references dbo.Cities(Id)
);
go


-- �������� ������� ����������
create table Employees (
     Id           int          not null identity(1, 1) constraint Employees_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Salary_check check (Salary > 1000),
	 constraint Employees_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go


-- �������� ������� ������������ ������������ �� ��������
create table Incidents (
     Id                int  not null identity(1, 1) constraint Incidents_PK primary key (Id),
	 IdPlot            int  not null,         -- ������� �����������
	 IdEmergencyType   int  not null,         -- ��� �����������
	 IdEmergencyCause  int  not null,         -- ������� �����������
	 IncDate           date not null,         -- ���� �����������
	 Damage            int  not null,         -- ������������ �����
	 
	 constraint Incidents_Damage_check check (Damage >= 0),
	  -- ����� � �������� �������
	 constraint FK_Incidents_Plots foreign key(IdPlot) references dbo.Plots(Id),
	 -- ����� � �������� ���� ��
	 constraint FK_Incidents_EmergencyTypes foreign key(IdEmergencyType) references dbo.EmergencyTypes(Id),
	 -- ����� � �������� ������� ��
	 constraint FK_Incidents_EmergencyCauses foreign key(IdEmergencyCause) references dbo.EmergencyCauses(Id)
);
go

-- �������� ������� ������� � ��������� ��
create table IncidentIners (
     Id          int not null identity(1, 1) constraint IncidentIners_PK primary key (Id),
	 IdIncident  int not null,         -- �����������
	 IdEmployee  int not null,         -- ��������(���������)
	 DaysAmount  int not null,         -- ���� �������
	 
	 constraint IncidentIners_DaysAmount_check check (DaysAmount > 0),
	 -- ����� � �������� ���� ��
	 constraint FK_IncidentIners_Incidents foreign key(IdIncident) references dbo.Incidents(Id),
	 -- ����� � �������� ������� ��
	 constraint FK_IncidentIners_Employees foreign key(IdEmployee) references dbo.Employees(Id)
);
go

-- �������� ������� ������������
create table Users (
     Id            int          not null identity(1, 1) constraint Users_PK primary key (Id),
	 [Login]       nvarchar(50) not null,                 -- �����
	 IdDepartment  int          not null,                 -- ��������� � ������� �������� ������������

	 -- ������ ���� ���������� ������
	 constraint Users_UNIQ unique([Login]),
	 -- ����� � �������� ���������
	 constraint FK_Users_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go


-- ���� �� ������� ���� �� ���� �������, ��������
-- ����������
if object_id('Cities') is null  or 
   object_id('JsonTable') is null  or
   object_id('Users') is null  or 
   object_id('Positions') is null  or 
   object_id('ProductionTypes') is null  or 
   object_id('CoalTypes') is null  or 
   object_id('EmergencyTypes') is null or
   object_id('EmergencyCauses') is null or
   object_id('Mines') is null or
   object_id('Plots') is null or
   object_id('Departments') is null or
   object_id('Employees') is null or
   object_id('IncidentIners') is null or
   object_id('Incidents') is null begin
   rollback transaction;
   print '';
   print '�� ��� ������� �������';
   print '';
   set noexec on;
end else
    commit transaction;

	
print '';
print '�������� ���� ������ � ������ ���������';
print '';

create index DepNameIndx on Departments(DepName);

create index YearStartEmplIndx on Employees(YearStart);