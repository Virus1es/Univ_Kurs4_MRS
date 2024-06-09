set noexec off
go

use master 
go

-- при отсутствии БД создать ее
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
print 'БД уже есть на сервере'
end;
go

use Kursach_BD;
go

-- удаление существующих вариантов таблиц
begin transaction;
print '';
print 'Удаление существующих таблиц:';
print '';

-- удалить старый вариант таблицы IncidentIners(Участие в устраниях ЧС)
if OBJECT_ID('IncidentIners') is not null begin
	drop table IncidentIners;
	print 'Удалена таблица IncidentIners';
end;

-- удалить старый вариант таблицы Incidents(Чрезвычайные происшествия на участках)
if OBJECT_ID('Incidents') is not null begin
	drop table Incidents;
	print 'Удалена таблица Incidents';
end;

-- удалить старый вариант таблицы Employees(Сотрудники)
if OBJECT_ID('Employees') is not null begin
	drop table Employees;
	print 'Удалена таблица Employees';
end;

-- удалить старый вариант таблицы Users(Пользователи)
if OBJECT_ID('Users') is not null begin
	drop table Users;
	print 'Удалена таблица Users';
end;

-- удалить старый вариант таблицы Departments(Отделения)
if OBJECT_ID('Departments') is not null begin
	drop table Departments;
	print 'Удалена таблица Departments';
end;

-- удалить старый вариант таблицы Plots(Участки)
if OBJECT_ID('Plots') is not null begin
	drop table Plots;
	print 'Удалена таблица Plots';
end;

-- удалить старый вариант таблицы Mines(Шахты)
if OBJECT_ID('Mines') is not null begin
	drop table Mines;
	print 'Удалена таблица Mines';
end;

-- удалить старый вариант таблицы Cities(Города)
if OBJECT_ID('Cities') is not null begin
	drop table Cities;
	print 'Удалена таблица Cities';
end;

-- удалить старый вариант таблицы Positions(Должности)
if OBJECT_ID('Positions') is not null begin
	drop table Positions;
	print 'Удалена таблица Positions';
end;

-- удалить старый вариант таблицы ProductionTypes(Типы выработки)
if OBJECT_ID('ProductionTypes') is not null begin
	drop table ProductionTypes;
	print 'Удалена таблица ProductionTypes';
end;

-- удалить старый вариант таблицы CoalTypes(Типы угля)
if OBJECT_ID('CoalTypes') is not null begin
	drop table CoalTypes;
	print 'Удалена таблица CoalTypes';
end;

-- удалить старый вариант таблицы EmergencyTypes(Типы ЧС)
if OBJECT_ID('EmergencyTypes') is not null begin
	drop table EmergencyTypes;
	print 'Удалена таблица EmergencyTypes';
end;

-- удалить старый вариант таблицы EmergencyCauses(Причины ЧС)
if OBJECT_ID('EmergencyCauses') is not null begin
	drop table EmergencyCauses;
	print 'Удалена таблица EmergencyCauses';
end;

-- удалить старый вариант таблицы JsonTable(Таблица Json ЛР №7)
if OBJECT_ID('JsonTable') is not null begin
	drop table JsonTable;
	print 'Удалена таблица JsonTable';
end;


-- Если осталась хотя бы одна таблица, откатить
-- транзакцию
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
   print 'Не все таблицы удалены'
   print ''

   set noexec on;
end else begin
   commit transaction;
   
   print ''
   print 'Удаление таблиц завершено'
   print ''
end;


begin transaction

-- создание таблицы Данные Json
create table JsonTable (
	 Id    int  not null identity(1, 1),  -- для автоинкремента
	 dataj nvarchar(max) null,            -- хранение json

	 constraint JsonTable_PK primary key (Id)
);
go

-- создание таблицы Города
create table Cities (
     Id       int          not null identity(1, 1),  -- для автоинкремента
	 CityName nvarchar(50) not null,                 -- название города
	 
	 constraint Cities_PK primary key (Id)
);
go


-- создание таблицы Должности
create table Positions (
     Id           int          not null identity(1, 1),  -- для автоинкремента
	 PositionName nvarchar(50) not null,                 -- название должности
	 
	 constraint Positions_PK primary key (Id)
);
go


-- создание таблицы Типы выработки
create table ProductionTypes (
     Id       int          not null identity(1, 1),  -- для автоинкремента
	 TypeName nvarchar(50) not null,                 -- название типа выработки
	 
	 constraint ProductionTypes_PK primary key (Id)
);
go


-- создание таблицы Типы угля
create table CoalTypes (
     Id       int          not null identity(1, 1),  -- для автоинкремента
	 TypeName nvarchar(50) not null,                 -- название типа угля
	 
	 constraint CoalTypes_PK primary key (Id)
);
go


-- создание таблицы Типы ЧС
create table EmergencyTypes (
     Id       int          not null identity(1, 1),  -- для автоинкремента
	 TypeName nvarchar(50) not null,                 -- название типа ЧС
	 
	 constraint EmergencyTypess_PK primary key (Id)
);
go


-- создание таблицы Причины ЧС
create table EmergencyCauses (
     Id       int          not null identity(1, 1),  -- для автоинкремента
	 CauseName nvarchar(50) not null,                 -- название причины ЧС
	 
	 constraint EmergencyCauses_PK primary key (Id)
);
go


-- создание таблицы Шахты
create table Mines (
     Id         int          not null identity(1, 1) constraint Mines_PK primary key (Id),
	 MineName   nvarchar(50) not null,                 -- название шахты
	 IdCity     int          not null,                 -- город
	 MaxDepth   int          not null,                 -- максимальная глубина
	 Area       int          not null,                 -- площадь выработок

	 constraint Mines_MaxDepth_check check (MaxDepth > 0),
	 constraint Mines_Area_check check (Area > 0),
	 -- связь с таблицей Города
	 constraint FK_Mines_Cities foreign key(IdCity) references dbo.Cities(Id)
)WITH
(
    DATA_COMPRESSION = NONE ON PARTITIONS (MineName)
);
go


-- создание таблицы Участки
create table Plots (
     Id               int          not null identity(1, 1) constraint Plots_PK primary key (Id),
	 Number           nvarchar(20) not null,                 -- Числено-буквенный номер участка
	 LengthPlot       int          not null,                 -- длина участка
	 IdProductionType int          not null,                 -- тип выработки
	 IdCoalType       int          not null,                 -- тип угля
	 YearStart        int          not null,                 -- год ввода в действие
	 IdMine           int          not null,                 -- шахта в которой находиться участок
	 
	 constraint Plots_YearStart_check check (YearStart between 1800 and Year(getdate())),
	 -- связь с таблицей Типы выработки
	 constraint FK_Plots_ProductionTypes foreign key(IdProductionType) references dbo.ProductionTypes(Id),
	 -- связь с таблицей Типы угля
	 constraint FK_Plots_CoalTypes foreign key(IdCoalType) references dbo.CoalTypes(Id),
	 -- связь с таблицей Шахты
	 constraint FK_Plots_Mines foreign key(IdMine) references dbo.Mines(Id)
);
go

-- создание таблицы Отделения ГСС
create table Departments (
     Id           int          not null identity(1, 1) constraint Departments_PK primary key (Id),
	 DepName      nvarchar(50) not null,                 -- название отделения
	 IdCity       int          not null,                 -- город
	 Phone        nvarchar(30) not null,                 -- телефон
	 YearCreation int          not null,                 -- год создания
	 
	 constraint Departments_YearCreation_check check (YearCreation between 1800 and Year(getdate())),
	 -- связь с таблицей Города
	 constraint FK_Departments_Cities foreign key(IdCity) references dbo.Cities(Id)
);
go


-- создание таблицы Сотрудники
create table Employees (
     Id           int          not null identity(1, 1) constraint Employees_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Salary_check check (Salary > 1000),
	 constraint Employees_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go


-- создание таблицы Чрезвычайные происшествия на участках
create table Incidents (
     Id                int  not null identity(1, 1) constraint Incidents_PK primary key (Id),
	 IdPlot            int  not null,         -- участок проишествия
	 IdEmergencyType   int  not null,         -- тип проишествия
	 IdEmergencyCause  int  not null,         -- причина проишествия
	 IncDate           date not null,         -- дата проишествия
	 Damage            int  not null,         -- материальный ущерб
	 
	 constraint Incidents_Damage_check check (Damage >= 0),
	  -- связь с таблицей Участки
	 constraint FK_Incidents_Plots foreign key(IdPlot) references dbo.Plots(Id),
	 -- связь с таблицей Типы ЧС
	 constraint FK_Incidents_EmergencyTypes foreign key(IdEmergencyType) references dbo.EmergencyTypes(Id),
	 -- связь с таблицей Причины ЧС
	 constraint FK_Incidents_EmergencyCauses foreign key(IdEmergencyCause) references dbo.EmergencyCauses(Id)
);
go

-- создание таблицы Участие в устраниях ЧС
create table IncidentIners (
     Id          int not null identity(1, 1) constraint IncidentIners_PK primary key (Id),
	 IdIncident  int not null,         -- проишествие
	 IdEmployee  int not null,         -- участник(сотрудник)
	 DaysAmount  int not null,         -- дней участия
	 
	 constraint IncidentIners_DaysAmount_check check (DaysAmount > 0),
	 -- связь с таблицей Типы ЧС
	 constraint FK_IncidentIners_Incidents foreign key(IdIncident) references dbo.Incidents(Id),
	 -- связь с таблицей Причины ЧС
	 constraint FK_IncidentIners_Employees foreign key(IdEmployee) references dbo.Employees(Id)
);
go

-- создание таблицы Пользователи
create table Users (
     Id            int          not null identity(1, 1) constraint Users_PK primary key (Id),
	 [Login]       nvarchar(50) not null,                 -- логин
	 IdDepartment  int          not null,                 -- Отделение в котором работает пользователь

	 -- должны быть уникальные логины
	 constraint Users_UNIQ unique([Login]),
	 -- связь с таблицей Отделения
	 constraint FK_Users_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go


-- Если не создана хотя бы одна таблица, откатить
-- транзакцию
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
   print 'Не все таблицы созданы';
   print '';
   set noexec on;
end else
    commit transaction;

	
print '';
print 'Создание базы данных и таблиц выполнено';
print '';

create index DepNameIndx on Departments(DepName);

create index YearStartEmplIndx on Employees(YearStart);