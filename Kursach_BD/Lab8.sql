-- ЛР №8

Drop Table IF Exists Employees_Part;
drop PARTITION SCHEME Employees_Part_Scheme;
drop PARTITION FUNCTION Employees_Part_YearStart;


CREATE PARTITION FUNCTION Employees_Part_YearStart (int)
AS RANGE LEFT FOR VALUES (1975, 1991, 2011);
go
-- Создание схемы секционирования
CREATE PARTITION SCHEME Employees_Part_Scheme
AS PARTITION Employees_Part_YearStart ALL TO ([PRIMARY]) ;
go
-- Создание секционированной таблицы по списку
create table Employees_Part (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Part_Salary_check check (Salary > 1000),
	 constraint Employees_Part_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Part_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Part_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id, YearStart)
)ON Employees_Part_Scheme(YearStart);
go


-- Заполнение значениями, меняя значения года
declare @i int = 1;
while @i < 10000 begin
INSERT INTO Employees_Part (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
VALUES 
    ('Иван', 'Иванов', 'Иванович', 1, 1500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1980-05-20', 1),
    ('Мария', 'Петрова', 'Андреевна', 2, 2000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1982-07-15', 2),
    ('Алексей', 'Смирнов', 'Викторович', 3, 2500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1985-03-25', 3),
    ('Ольга', 'Кузнецова', 'Михайловна', 4, 3000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1990-08-10', 1),
    ('Сергей', 'Попов', 'Александрович', 2, 3500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1995-12-05', 2),
    ('Анна', 'Соколова', 'Петровна', 1, 4000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1992-11-30', 3);
	set @i += 1;
end
go

select count(*) from Employees_Part;
go

drop table if exists Employees_Normal;
-- создание обычной таблицы
create table Employees_Normal (
     Id           int          not null identity(1, 1) constraint Employees_Normal_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Normal_Salary_check check (Salary > 1000),
	 constraint Employees_Normal_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Normal_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Normal_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go

-- копирование данных
INSERT INTO Employees_Normal (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
SELECT FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment
FROM Employees_Part;
go

-- создание индексов
drop index if exists partInd1;
drop index if exists partInd2;
drop index if exists partInd3;
drop index if exists normInd1;
drop index if exists normInd2;
drop index if exists normInd3;
go

create index partInd1 on Employees_Part(YearStart);
create index partInd2 on Employees_Part(Id);
create index partInd3 on Employees_Part(IdPosition);
go


create index normInd1 on Employees_Normal(YearStart);
create index normInd2 on Employees_Normal(Id);
create index normInd3 on Employees_Normal(IdPosition);
go

-- сравнение

SET STATISTICS TIME ON;

select * from Employees_Normal;
go

SET STATISTICS TIME OFF;


SET STATISTICS TIME ON;

select * from Employees_Part;
go

SET STATISTICS TIME OFF;

-- создание секционной таблицы по хешу

Drop Table IF Exists Employees_Part_h;
drop PARTITION SCHEME Employees_Part_Scheme_h;
drop PARTITION FUNCTION Employees_Part_YearStart_h;
go

CREATE PARTITION FUNCTION Employees_Part_h(INT)
AS RANGE LEFT FOR VALUES (1, 10, 100, 1000)
GO
-- Создание схемы секционирования
CREATE PARTITION SCHEME Employees_Part_Scheme_h
AS PARTITION Employees_Part_h ALL TO ([PRIMARY]) ;
go
-- Создание секционированной таблицы по хешу
create table Employees_Part_h (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Part_h_Salary_check check (Salary > 1000),
	 constraint Employees_Part_h_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Part_h_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Part_h_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id)
) on Employees_Part_Scheme_h(Id);
go 

-- Заполнение значениями, меняя значения года
declare @i int = 1;
while @i < 10000 begin
INSERT INTO Employees_Part_h (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
VALUES 
    ('Иван', 'Иванов', 'Иванович', 1, 1500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1980-05-20', 1),
    ('Мария', 'Петрова', 'Андреевна', 2, 2000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1982-07-15', 2),
    ('Алексей', 'Смирнов', 'Викторович', 3, 2500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1985-03-25', 3),
    ('Ольга', 'Кузнецова', 'Михайловна', 4, 3000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1990-08-10', 1),
    ('Сергей', 'Попов', 'Александрович', 2, 3500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1995-12-05', 2),
    ('Анна', 'Соколова', 'Петровна', 1, 4000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1992-11-30', 3);
	set @i += 1;
end
go

-- Создание обычной таблицы и копирование в нее данных
drop table if exists Employees_Normal_h;
-- создание обычной таблицы
create table Employees_Normal_h (
     Id           int          not null identity(1, 1) constraint Employees_Normal_h_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Normal_h_Salary_check check (Salary > 1000),
	 constraint Employees_Normal_h_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Normal_h_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Normal_h_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go

-- копирование данных
INSERT INTO Employees_Normal_h (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
SELECT FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment
FROM Employees_Part_h;
go

-- создание индексов
drop index if exists partInd1;
drop index if exists partInd2;
drop index if exists partInd3;
drop index if exists normInd1;
drop index if exists normInd2;
drop index if exists normInd3;
go

create index partInd4 on Employees_Part_h(YearStart);
create index partInd5 on Employees_Part_h(Id);
create index partInd6 on Employees_Part_h(IdPosition);
go


create index normInd4 on Employees_Normal_h(YearStart);
create index normInd5 on Employees_Normal_h(Id);
create index normInd6 on Employees_Normal_h(IdPosition);
go

-- сравнение

SET STATISTICS TIME ON;

select * from Employees_Normal_h;
go

SET STATISTICS TIME OFF;


SET STATISTICS TIME ON;

select * from Employees_Part_h;
go

SET STATISTICS TIME OFF;


-- Присоединение новой таблицы к партиции по списку
create table Employees_New_List_Part (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- имя
	 Surname      nvarchar(60) not null,                 -- фамилия
	 Patronymic   nvarchar(50) not null,                 -- отчество
	 IdPosition   int          not null,                 -- занимаемая должность
	 Salary       int          not null,                 -- оклад
	 YearStart    int          not null,                 -- год начала работы в отделении
	 Birthday     date         not null,                 -- дата рождения
	 IdDepartment int          not null,                 -- отделение в которм работает сотрудник
	 
	 constraint Employees_Part_Salary_check check (Salary > 1000),
	 constraint Employees_Part_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- связь с таблицей Должности
	 constraint FK_Employees_Part_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- связь с таблицей Отделения ГСС
	 constraint FK_Employees_Part_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id, YearStart)
)ON Employees_Part_Scheme(YearStart);
go