use Kursach_BD;
go

-- ���������� ������� ������
begin transaction        
insert into Cities(CityName) 
values
    ('������'),       -- 1
    ('��������'),     -- 2
    ('����������'),   -- 3
    ('����������'),   -- 4
    ('��������'),     -- 5
    ('��������'),     -- 6
    ('�������'),     -- 7
    ('�������'),      -- 8
    ('��������'),     -- 9
    ('����������'),   -- 10
    ('���������'),    -- 11
    ('���������'),    -- 12
    ('�����'),        -- 13
    ('�����������'),  -- 14
	('���������');    -- 15
commit transaction;

-- ���������� ������� ���� ����
begin transaction        
insert into CoalTypes(TypeName) 
values
    ('��������'),       -- 1
    ('�����������'),    -- 2
    ('��������������'), -- 3
    ('�������'),        -- 4
    ('��������'),       -- 5
	('�����');          -- 6
commit transaction;

-- ���������� ������� ���������
begin transaction        
insert into Positions(PositionName) 
values
    ('�������� ������'), -- 1
    ('�������� ������'), -- 2
    ('�������� ����'),   -- 3
    ('����');            -- 4
commit transaction;

-- ���������� ������� ���� ���������
begin transaction        
insert into ProductionTypes(TypeName) 
values
    ('������������'),   -- 1
    ('��������������'), -- 2
    ('���������');      -- 3
commit transaction;

-- ���������� ������� ���� ��
begin transaction        
insert into EmergencyTypes(TypeName) 
values
    ('����� ����'),     -- 1
    ('�����'),          -- 2
    ('����� ����'),     -- 3
    ('����������'),     -- 4
    ('�������������'),  -- 5
    ('������� ����');   -- 6
commit transaction;

-- ���������� ������� ������� ��
begin transaction        
insert into EmergencyCauses(CauseName) 
values
    ('�����������'),    -- 1
    ('������������');   -- 2
commit transaction;

-- ���������� ������� �����
begin transaction        
insert into Mines(MineName, IdCity, MaxDepth, Area) 
values
    ('�������', 1, 3000, 450),    -- 1
    ('������', 3, 1800, 350),    -- 2
    ('�������', 8, 3500, 550),    -- 3
    ('������',  5, 3010, 455),    -- 4
    ('�������', 1, 2700, 500);    -- 5
commit transaction;

-- ���������� ������� ������� �����
begin transaction        
insert into Plots(Number, LengthPlot, YearStart, IdProductionType, IdCoalType, IdMine) 
values
    ('��1001', 1500, 1955, 1, 4, 1),    -- 1
    ('��2302', 1350, 1988, 3, 5, 1),    -- 2
    ('��9011',  800, 2001, 2, 3, 4),    -- 3
    ('��8811', 1050, 1976, 1, 3, 2),    -- 4
    ('��7712', 1700, 1994, 2, 1, 3);    -- 5
commit transaction;

-- ���������� ������� ��������� ���
begin transaction        
insert into Departments(DepName, IdCity, Phone, YearCreation) 
values
    ('�������������',  1, '+79493129311', 1990),    -- 1
    ('��������',       3, '+79493758247', 2005),    -- 2
    ('�������� �����', 8, '+79493754891', 1980),    -- 3
    ('������',         5, '+79493587123', 1940),    -- 4
    ('������������',   7, '+79493758374', 1999);    -- 5
commit transaction;

-- ���������� ������� ���������
begin transaction        
insert into Employees(Surname, FirstName, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment) 
values
	('�������',   '�������',   '����������',     4, 25000, 2022, '1999-10-11', 1), -- 1
	('��������',  '�����',     '��������',       4, 27000, 2021, '1988-07-01', 1), -- 2
	('������',    '����',      '����������',     2, 25000, 2007, '1978-05-15', 1), -- 3
	('��������',  '�����',     '��������',      3, 55000, 2010, '1969-04-07', 1), -- 4
	('��������',  '������',    '������������',   1, 85000, 2002, '1979-11-11', 1), -- 5
	('�������',   '���������', '����������',     4, 28500, 2012, '1990-01-11', 1), -- 6

	('�������',   '�������',   '���������',      4, 30000, 2002, '1998-09-22', 2), -- 7
	('���������', '�����',     '����������',     4, 29000, 2018, '1989-08-21', 2), -- 8
	('���������', '���������', '���������',      1, 95000, 2004, '1969-01-11', 2), -- 9
	('������',    '�������',   '��������',       2, 65000, 2011, '1973-10-11', 2), -- 10

	('�����',     '�������',   '����������',     3, 45000, 2019, '1979-12-26', 3), -- 11
	('�����',     '������',    '����������',     1, 85500, 2003, '1971-10-21', 3), -- 12
	('�������',   '����',     '���������',      2, 55500, 2002, '1982-02-01', 3), -- 13

	('�������',  '�����',     '����������',     1, 25000, 2022, '1974-03-07', 4), -- 14
	('������',    '�������',   '���������',      4, 25000, 2022, '1999-10-11', 4), -- 15
	('���������', '�����',     '�������������',  4, 25000, 2022, '2001-12-23', 4), -- 16

	('�������',   '������',    '�������������',  3, 45000, 2022, '1991-10-30', 5), -- 16
	('�������',   'Ը���',     '��������������', 1, 95000, 2022, '1995-10-11', 5), -- 17
	('�����',     '����',      '����������',     2, 72000, 2022, '1989-05-09', 5), -- 18
	('���������', '���������', '�����������',    2, 69500, 2022, '1979-02-21', 5); -- 19
commit transaction;

-- ���������� ������� ������������ ������������ �� ��������
begin transaction        
insert into Incidents(IdPlot, IdEmergencyType, IdEmergencyCause, IncDate, Damage) 
values
    (1, 1, 1, '2022-10-11', 390000),    -- 1
    (3, 3, 2, '2023-03-01', 550000),    -- 2
    (5, 6, 2, '2022-02-23', 400000),    -- 3
    (1, 5, 1, '2023-01-21', 700000),    -- 4
    (2, 4, 2, '2023-01-01', 565000);    -- 5
commit transaction;

-- ���������� ������� ������� � ��������� ��
begin transaction        
insert into IncidentIners(IdIncident, IdEmployee, DaysAmount) 
values
    (1,  3,  4),    -- 1
    (1,  2,  7),    -- 2
    (1, 10, 15),    -- 3
    (1,  1,  5),    -- 4

    (2,  5, 18),   -- 5
    (2,  8,  5),   -- 6
    (2,  6, 11),   -- 7
    (2, 13, 25),   -- 8

    (5, 17, 14),   -- 9
    (5, 16, 16),   -- 10
    (5,  3, 5),    -- 11

    (3,  4, 2),    -- 12
    (4, 18, 3);    -- 13
commit transaction;

-- ���������� ������� ������������(��������� ���������)
begin transaction        
insert into Users([Login], IdDepartment) 
values
    ('admin001',    1),    -- 1
    ('comand001',   1),    -- 2
    ('employee001', 1),    -- 3

    ('admin002',    2),    -- 4
    ('comand002',   2),    -- 5
    ('employee002', 2);    -- 6
commit transaction;


-- ���������� ������������� ��
begin transaction
----------------------------------------------------
CREATE LOGIN admin007   
    WITH PASSWORD = '0123456';
GO  

CREATE USER admin007 FOR LOGIN admin007;  
GO  

ALTER ROLE [admin] ADD MEMBER admin007 ;  
GO 

CREATE LOGIN admin002   
    WITH PASSWORD = '7654321';
GO  

CREATE USER admin002 FOR LOGIN admin002;  
GO  

ALTER ROLE [admin] ADD MEMBER admin002 ;  
GO 
----------------------------------------------------
CREATE LOGIN comand001   
    WITH PASSWORD = '1111111';
GO  

CREATE USER comand001 FOR LOGIN comand001;  
GO  

ALTER ROLE comandor ADD MEMBER comand001 ;  
GO 

CREATE LOGIN comand002   
    WITH PASSWORD = '2222222';
GO  

CREATE USER comand002 FOR LOGIN comand002;  
GO  

ALTER ROLE comandor ADD MEMBER comand002 ;  
GO 

----------------------------------------------------
CREATE LOGIN employee001   
    WITH PASSWORD = '7777777';
GO  

CREATE USER employee001 FOR LOGIN employee001;  
GO  

ALTER ROLE employee ADD MEMBER employee001 ;  
GO 

CREATE LOGIN employee002   
    WITH PASSWORD = '6666666';
GO  

CREATE USER employee002 FOR LOGIN employee002;  
GO  

ALTER ROLE employee ADD MEMBER employee002 ;  
GO
commit transaction;