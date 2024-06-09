EXEC sp_helprolemember;
go

select * from sys.database_principals where type_desc = 'SQL_USER';
go

SELECT SUSER_SID('comand001');  
GO 

select name from sys.sql_logins 
where PWDCOMPARE('0123456', password_hash) = 1;
go

create policy admin on role as restrictive for all to admin001 
using (role = CURRENT_USER);