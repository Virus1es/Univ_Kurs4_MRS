-- 6 ��������� ��� �������� ������

-- before insert(������ ������� ����� � ����� ���������� �� ������ ������ ����� � ������������ ���������)
create or alter trigger OnBeforeInsertEmployees on Employees
for insert as
begin
	-- ���������� �������
	declare @countFuture int = 0, @count int = @@rowcount;

	-- ������� ���������� ������� � ����������
	select
		@countFuture = count(*)
	from
		inserted
	where
		YearStart < (select Departments.YearCreation from Departments where inserted.IdDepartment = Departments.Id);

	-- ���� ���� ���� ���� ������ - ����� �������
	if @countFuture > 0 begin
		print('�� �������� �������� ����� � ����� ���������� �� ������ ������ ����� � ������������ ���������');
		rollback tran;
	end
	else raiserror('� ������� Employees ��������� �������: %d', 0, 1, @count);

end
go

-- before update(������ ��������� ��������� � �������� ������)
create or alter trigger OnBeforeUpdateMines on Mines
for update as
begin
	-- ������� � ���������, ���������� ������� ��� ���������
	declare @HasPass int, @count int = @@rowcount;

	-- ���� ����� ���������� �������� �����
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
				Cities.CityName = '������');
	
	-- ���� ���� ���� �� ���� - ����� ���������
	if @HasPass > 0 begin
		print('�� �������� �������� ���������� � �������� �����');
		rollback tran;
	end
	else raiserror('� ������� Mines �������� �������: %d', 0, 1, @count);

end
go

-- before delete(��������� �������� ���������)
create or alter trigger OnBeforeDeleteDepartments on Departments
for delete as
begin
	delete from Employees
	where Employees.IdDepartment in
	(select Id from deleted);
end
go

-- after insert(������ ������� ����� �� ��������� 18 ���)
create or alter trigger OnAfterInsertEmployees on Employees
after insert as
begin
	-- ���������� �������
	declare @countFuture int = 0, @count int = @@rowcount;

	-- ������� ���������� ������� � ����������
	select
		@countFuture = count(*)
	from
		inserted
	where
		YearStart - Year(Birthday) < 18;

	-- ���� ���� ���� ���� ������ - ����� �������
	if @countFuture > 0 begin
		print('�� �������� �������� ����� �� ��������� 18 ���');
		rollback tran;
	end
	else raiserror('� ������� Employees ��������� �������: %d', 0, 1, @count);

end
go

-- after update(������ �� ��������� �������� � �������� "�����")
create or alter trigger OnAfterUpdateEmployees on Employees
after update as
begin
	-- ������� � ���������, ���������� ������� ��� ���������
	declare @HasPass int, @count int = @@rowcount;

	-- ���� ����� ���������� �������� � ������ ��������
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
				Employees.Surname = '�����'
		);
	

	-- ���� ���� ���� �� ���� - ����� ���������
	if @HasPass > 0 begin
		print('�� �������� �������� ���������� � ������� � �������� �������');
		rollback tran;
	end
	else raiserror('� ������� Employees �������� �������: %d', 0, 1, @count);

end
go


-- after delete(������ �������� ������� �� ������� �����)
create or alter trigger OnAfterDeleteEmployees on Incidents
after delete as
begin
	-- ���������� ������� ��������� �� ������� �����
	declare @countNow int = 0, @now date = GetDate(),  @count int = @@rowcount;

	-- ������� ������� ����� �������
	select
		@countNow = count(*)
	from
		deleted
	where
		MONTH(IncDate) = MONTH(@now) and YEAR(IncDate) = YEAR(@now);

	-- ���� ���� ���� �� ���� - ����� ��������
	if @countNow > 0 begin
		print('�� �������� ������� ����������� �� ������� �����');
		rollback tran;
	end
	else raiserror('�� ������� Incidents ������� �������: %d', 0, 1, @count);

end
go


create or alter view ViewCity as
select
	Cities.Id
	, Cities.CityName
	from 
		dbo.Cities;
go

-- 3 �������� ��� �������������
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