-- �� �8

Drop Table IF Exists Employees_Part;
drop PARTITION SCHEME Employees_Part_Scheme;
drop PARTITION FUNCTION Employees_Part_YearStart;


CREATE PARTITION FUNCTION Employees_Part_YearStart (int)
AS RANGE LEFT FOR VALUES (1975, 1991, 2011);
go
-- �������� ����� ���������������
CREATE PARTITION SCHEME Employees_Part_Scheme
AS PARTITION Employees_Part_YearStart ALL TO ([PRIMARY]) ;
go
-- �������� ���������������� ������� �� ������
create table Employees_Part (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Part_Salary_check check (Salary > 1000),
	 constraint Employees_Part_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Part_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Part_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id, YearStart)
)ON Employees_Part_Scheme(YearStart);
go


-- ���������� ����������, ����� �������� ����
declare @i int = 1;
while @i < 10000 begin
INSERT INTO Employees_Part (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
VALUES 
    ('����', '������', '��������', 1, 1500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1980-05-20', 1),
    ('�����', '�������', '���������', 2, 2000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1982-07-15', 2),
    ('�������', '�������', '����������', 3, 2500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1985-03-25', 3),
    ('�����', '���������', '����������', 4, 3000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1990-08-10', 1),
    ('������', '�����', '�������������', 2, 3500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1995-12-05', 2),
    ('����', '��������', '��������', 1, 4000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1992-11-30', 3);
	set @i += 1;
end
go

select count(*) from Employees_Part;
go

drop table if exists Employees_Normal;
-- �������� ������� �������
create table Employees_Normal (
     Id           int          not null identity(1, 1) constraint Employees_Normal_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Normal_Salary_check check (Salary > 1000),
	 constraint Employees_Normal_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Normal_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Normal_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go

-- ����������� ������
INSERT INTO Employees_Normal (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
SELECT FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment
FROM Employees_Part;
go

-- �������� ��������
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

-- ���������

SET STATISTICS TIME ON;

select * from Employees_Normal;
go

SET STATISTICS TIME OFF;


SET STATISTICS TIME ON;

select * from Employees_Part;
go

SET STATISTICS TIME OFF;

-- �������� ���������� ������� �� ����

Drop Table IF Exists Employees_Part_h;
drop PARTITION SCHEME Employees_Part_Scheme_h;
drop PARTITION FUNCTION Employees_Part_YearStart_h;
go

CREATE PARTITION FUNCTION Employees_Part_h(INT)
AS RANGE LEFT FOR VALUES (1, 10, 100, 1000)
GO
-- �������� ����� ���������������
CREATE PARTITION SCHEME Employees_Part_Scheme_h
AS PARTITION Employees_Part_h ALL TO ([PRIMARY]) ;
go
-- �������� ���������������� ������� �� ����
create table Employees_Part_h (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Part_h_Salary_check check (Salary > 1000),
	 constraint Employees_Part_h_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Part_h_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Part_h_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id)
) on Employees_Part_Scheme_h(Id);
go 

-- ���������� ����������, ����� �������� ����
declare @i int = 1;
while @i < 10000 begin
INSERT INTO Employees_Part_h (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
VALUES 
    ('����', '������', '��������', 1, 1500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1980-05-20', 1),
    ('�����', '�������', '���������', 2, 2000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1982-07-15', 2),
    ('�������', '�������', '����������', 3, 2500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1985-03-25', 3),
    ('�����', '���������', '����������', 4, 3000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1990-08-10', 1),
    ('������', '�����', '�������������', 2, 3500, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1995-12-05', 2),
    ('����', '��������', '��������', 1, 4000, FLOOR(1970 + RAND() * (2024 - 1970 + 1)), '1992-11-30', 3);
	set @i += 1;
end
go

-- �������� ������� ������� � ����������� � ��� ������
drop table if exists Employees_Normal_h;
-- �������� ������� �������
create table Employees_Normal_h (
     Id           int          not null identity(1, 1) constraint Employees_Normal_h_PK primary key (Id),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Normal_h_Salary_check check (Salary > 1000),
	 constraint Employees_Normal_h_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Normal_h_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Normal_h_Departments foreign key(IdDepartment) references dbo.Departments(Id)
);
go

-- ����������� ������
INSERT INTO Employees_Normal_h (FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment)
SELECT FirstName, Surname, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment
FROM Employees_Part_h;
go

-- �������� ��������
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

-- ���������

SET STATISTICS TIME ON;

select * from Employees_Normal_h;
go

SET STATISTICS TIME OFF;


SET STATISTICS TIME ON;

select * from Employees_Part_h;
go

SET STATISTICS TIME OFF;


-- ������������� ����� ������� � �������� �� ������
create table Employees_New_List_Part (
     Id           int          not null identity(1, 1),
	 FirstName    nvarchar(50) not null,                 -- ���
	 Surname      nvarchar(60) not null,                 -- �������
	 Patronymic   nvarchar(50) not null,                 -- ��������
	 IdPosition   int          not null,                 -- ���������� ���������
	 Salary       int          not null,                 -- �����
	 YearStart    int          not null,                 -- ��� ������ ������ � ���������
	 Birthday     date         not null,                 -- ���� ��������
	 IdDepartment int          not null,                 -- ��������� � ������ �������� ���������
	 
	 constraint Employees_Part_Salary_check check (Salary > 1000),
	 constraint Employees_Part_YearStart_check check (YearStart between 1960 and Year(getdate())),
	 -- ����� � �������� ���������
	 constraint FK_Employees_Part_Positions foreign key(IdPosition) references dbo.Positions(Id),
	 -- ����� � �������� ��������� ���
	 constraint FK_Employees_Part_Departments foreign key(IdDepartment) references dbo.Departments(Id),
	 PRIMARY KEY (Id, YearStart)
)ON Employees_Part_Scheme(YearStart);
go