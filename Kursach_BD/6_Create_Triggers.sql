-- 6 триггеров для основных таблиц

-- before insert(запрет вставки людей с годом вступления на службу раньше ввода в эксплуатацию отделения)
create or alter trigger OnBeforeInsertEmployees on Employees
for insert as
begin
	-- количество записей
	declare @countFuture int = 0, @count int = @@rowcount;

	-- считаем количество записей в ставляемых
	select
		@countFuture = count(*)
	from
		inserted
	where
		YearStart < (select Departments.YearCreation from Departments where inserted.IdDepartment = Departments.Id);

	-- если есть хоть одна запись - откат вставки
	if @countFuture > 0 begin
		print('Не возможно вставить людей с годом вступления на службу раньше ввода в эксплуатацию отделения');
		rollback tran;
	end
	else raiserror('В таблицу Employees добавлено записей: %d', 0, 1, @count);

end
go

-- before update(запрет изменения иформации о донецких шахтах)
create or alter trigger OnBeforeUpdateMines on Mines
for update as
begin
	-- клиенты с паспортом, количество записей для изменения
	declare @HasPass int, @count int = @@rowcount;

	-- ищем среди изменяемых донецкую шахту
	select
		@HasPass = count(*)
	from
		deleted
	where
		 Id in (
			select 
				Mines.Id
			from
				Mines join Cities on Mines.IdCity = Cities.Id
			where
				Cities.CityName = 'Донецк');
	
	-- если есть хотя бы один - откат изменения
	if @HasPass > 0 begin
		print('Не возможно изменить информацию о донецкой шахте');
		rollback tran;
	end
	else raiserror('В таблице Mines изменено записей: %d', 0, 1, @count);

end
go

-- before delete(каскадное удаление отделения)
create or alter trigger OnBeforeDeleteDepartments on Departments
for delete as
begin
	delete from Employees
	where Employees.IdDepartment in
	(select Id from deleted);
end
go

-- after insert(запрет вставки людей не достигших 18 лет)
create or alter trigger OnAfterInsertEmployees on Employees
after insert as
begin
	-- количество записей
	declare @countFuture int = 0, @count int = @@rowcount;

	-- считаем количество записей в ставляемых
	select
		@countFuture = count(*)
	from
		inserted
	where
		YearStart - Year(Birthday) < 18;

	-- если есть хоть одна запись - откат вставки
	if @countFuture > 0 begin
		print('Не возможно вставить людей не достигших 18 лет');
		rollback tran;
	end
	else raiserror('В таблицу Employees добавлено записей: %d', 0, 1, @count);

end
go

-- after update(запрет на изменение рабочего с фамилией "Гринь")
create or alter trigger OnAfterUpdateEmployees on Employees
after update as
begin
	-- клиенты с паспортом, количество записей для изменения
	declare @HasPass int, @count int = @@rowcount;

	-- ищем среди изменяемых рабочего с нужной фамилией
	select
		@HasPass = count(*)
	from
		deleted
	where
		 Id in (
			select 
				Employees.Id
			from
				Employees
			where
				Employees.Surname = 'Гринь'
		);
	

	-- если есть хотя бы один - откат изменения
	if @HasPass > 0 begin
		print('Не возможно изменить информацию о рабочем с фамилией «Гринь»');
		rollback tran;
	end
	else raiserror('В таблице Employees изменено записей: %d', 0, 1, @count);

end
go


-- after delete(запрет удаления записей за текущий месяц)
create or alter trigger OnAfterDeleteEmployees on Incidents
after delete as
begin
	-- количество записей удаляемых за текущий месяц
	declare @countNow int = 0, @now date = GetDate(),  @count int = @@rowcount;

	-- считаем сколько таких записей
	select
		@countNow = count(*)
	from
		deleted
	where
		MONTH(IncDate) = MONTH(@now) and YEAR(IncDate) = YEAR(@now);

	-- если есть хотя бы одна - откат удаления
	if @countNow > 0 begin
		print('Не возможно удалить проишествия за текущий месяц');
		rollback tran;
	end
	else raiserror('Из таблицы Incidents удалено записей: %d', 0, 1, @count);

end
go


create or alter view ViewCity as
select
	Cities.Id
	, Cities.CityName
	from 
		dbo.Cities;
go

-- 3 тригерра для представления
-- INSTEAD OF INSERT
create or alter trigger OnInstesdInsertViewCity on ViewCity
INSTEAD OF insert as
begin
insert into Cities(CityName) select CityName from inserted;
end
go

-- INSTEAD OF UPDATE
create or alter trigger OnInstesdUpdateViewCity on ViewCity
INSTEAD OF update as
begin
update Cities set CityName = (select CityName from deleted)
where Cities.Id = (select Id from deleted);
end
go

-- INSTEAD OF DELETE
create or alter trigger OnInstesdDeleteViewCity on ViewCity
INSTEAD OF delete as
begin
delete from Cities where Cities.Id = (select Id from deleted);
end
go