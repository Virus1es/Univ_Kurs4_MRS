use Kursach_BD;
go

-- Заполнение таблицы Города
begin transaction        
insert into Cities(CityName) 
values
    ('Донецк'),       -- 1
    ('Харцизск'),     -- 2
    ('Докучаевск'),   -- 3
    ('Ясиноватая'),   -- 4
    ('Макеевка'),     -- 5
    ('Еленовка'),     -- 6
    ('Шахтёрск'),     -- 7
    ('Снежное'),      -- 8
    ('Горловка'),     -- 9
    ('Новоазовск'),   -- 10
    ('Мариуполь'),    -- 11
    ('Волноваха'),    -- 12
    ('Торез'),        -- 13
    ('Амвросиевка'),  -- 14
	('Телманово');    -- 15
commit transaction;

-- Заполнение таблицы Типы угля
begin transaction        
insert into CoalTypes(TypeName) 
values
    ('Антрацит'),       -- 1
    ('Коксующийся'),    -- 2
    ('Энергетический'), -- 3
    ('Рядовой'),        -- 4
    ('Каменный'),       -- 5
	('Бурый');          -- 6
commit transaction;

-- Заполнение таблицы Должности
begin transaction        
insert into Positions(PositionName) 
values
    ('Командир отряда'), -- 1
    ('Командир взвода'), -- 2
    ('Командир роты'),   -- 3
    ('Боец');            -- 4
commit transaction;

-- Заполнение таблицы Типы выработки
begin transaction        
insert into ProductionTypes(TypeName) 
values
    ('Вертикальная'),   -- 1
    ('Горизонтальная'), -- 2
    ('Наклонная');      -- 3
commit transaction;

-- Заполнение таблицы Типы ЧС
begin transaction        
insert into EmergencyTypes(TypeName) 
values
    ('Обвал лавы'),     -- 1
    ('Пожар'),          -- 2
    ('Взрыв газа'),     -- 3
    ('Затопление'),     -- 4
    ('Загазирование'),  -- 5
    ('Выбросы угля');   -- 6
commit transaction;

-- Заполнение таблицы Причины ЧС
begin transaction        
insert into EmergencyCauses(CauseName) 
values
    ('Объективная'),    -- 1
    ('Субъективная');   -- 2
commit transaction;

-- Заполнение таблицы Шахты
begin transaction        
insert into Mines(MineName, IdCity, MaxDepth, Area) 
values
    ('Копалка', 1, 3000, 450),    -- 1
    ('Озёрная', 3, 1800, 350),    -- 2
    ('Опорная', 8, 3500, 550),    -- 3
    ('Жемчуг',  5, 3010, 455),    -- 4
    ('Красная', 1, 2700, 500);    -- 5
commit transaction;

-- Заполнение таблицы Участки шахты
begin transaction        
insert into Plots(Number, LengthPlot, YearStart, IdProductionType, IdCoalType, IdMine) 
values
    ('КА1001', 1500, 1955, 1, 4, 1),    -- 1
    ('КА2302', 1350, 1988, 3, 5, 1),    -- 2
    ('ЖГ9011',  800, 2001, 2, 3, 4),    -- 3
    ('ОЯ8811', 1050, 1976, 1, 3, 2),    -- 4
    ('ОЯ7712', 1700, 1994, 2, 1, 3);    -- 5
commit transaction;

-- Заполнение таблицы Отделения ГСС
begin transaction        
insert into Departments(DepName, IdCity, Phone, YearCreation) 
values
    ('Красноармейцы',  1, '+79493129311', 1990),    -- 1
    ('Отважные',       3, '+79493758247', 2005),    -- 2
    ('Северный оплот', 8, '+79493754891', 1980),    -- 3
    ('Верные',         5, '+79493587123', 1940),    -- 4
    ('Присягнувшие',   7, '+79493758374', 1999);    -- 5
commit transaction;

-- Заполнение таблицы Работники
begin transaction        
insert into Employees(Surname, FirstName, Patronymic, IdPosition, Salary, YearStart, Birthday, IdDepartment) 
values
	('Огурцов',   'Дмитрий',   'Генадьевич',     4, 25000, 2022, '1999-10-11', 1), -- 1
	('Колбасов',  'Кирил',     'Петрович',       4, 27000, 2021, '1988-07-01', 1), -- 2
	('Ушкало',    'Анна',      'Степановна',     2, 25000, 2007, '1978-05-15', 1), -- 3
	('Капустин',  'Игорь',     'Семёнович',      3, 55000, 2010, '1969-04-07', 1), -- 4
	('Пригожин',  'Андрей',    'Владимирович',   1, 85000, 2002, '1979-11-11', 1), -- 5
	('Иванова',   'Екатерина', 'Викторовна',     4, 28500, 2012, '1990-01-11', 1), -- 6

	('Баранов',   'Алексей',   'Кирилович',      4, 30000, 2002, '1998-09-22', 2), -- 7
	('Афендиков', 'Игнат',     'Степанович',     4, 29000, 2018, '1989-08-21', 2), -- 8
	('Синявская', 'Анастасия', 'Петровная',      1, 95000, 2004, '1969-01-11', 2), -- 9
	('Гусева',    'Валерия',   'Ивановна',       2, 65000, 2011, '1973-10-11', 2), -- 10

	('Гринь',     'Виталий',   'Генадьевич',     3, 45000, 2019, '1979-12-26', 3), -- 11
	('Быков',     'Андрей',    'Евгениевич',     1, 85500, 2003, '1971-10-21', 3), -- 12
	('Лобанов',   'Семён',     'Кирилович',      2, 55500, 2002, '1982-02-01', 3), -- 13

	('Журалёва',  'Елена',     'Николавена',     1, 25000, 2022, '1974-03-07', 4), -- 14
	('Иванов',    'Виталий',   'Яковлевич',      4, 25000, 2022, '1999-10-11', 4), -- 15
	('Зарудский', 'Роман',     'Александрович',  4, 25000, 2022, '2001-12-23', 4), -- 16

	('Томенко',   'Радион',    'Александрович',  3, 45000, 2022, '1991-10-30', 5), -- 16
	('Циганок',   'Фёдор',     'Константинович', 1, 95000, 2022, '1995-10-11', 5), -- 17
	('Гринь',     'Анна',      'Виталиевна',     2, 72000, 2022, '1989-05-09', 5), -- 18
	('Измайлова', 'Елизавета', 'Анатолиевна',    2, 69500, 2022, '1979-02-21', 5); -- 19
commit transaction;

-- Заполнение таблицы Чрезвычайные происшествия на участках
begin transaction        
insert into Incidents(IdPlot, IdEmergencyType, IdEmergencyCause, IncDate, Damage) 
values
    (1, 1, 1, '2022-10-11', 390000),    -- 1
    (3, 3, 2, '2023-03-01', 550000),    -- 2
    (5, 6, 2, '2022-02-23', 400000),    -- 3
    (1, 5, 1, '2023-01-21', 700000),    -- 4
    (2, 4, 2, '2023-01-01', 565000);    -- 5
commit transaction;

-- Заполнение таблицы Участие в устраниях ЧС
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

-- Заполнение таблицы Пользователи(уточнение отделения)
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


-- Добавление пользователей бд
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