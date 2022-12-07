
--1.a
--ID:hli248
-- DOWN
drop procedure if EXISTS  p_upsert_major
GO

-- UP Metadata
create procedure p_upsert_major (
    @major_code varchar(50),
    @major_name varchar(50),
    @major_id int
)as begin 
    if exists (select major_code from dbo.majors where major_code=@major_code ) begin
        update dbo.majors
        set major_name=@major_name where major_id=@major_id
    end
    ELSE begin
        insert into dbo.majors 
            (major_code,major_name,major_id)
        VALUES
            (@major_code,@major_name,@major_id)
    end    
end

--1.b
--ID:hli248
-- UP Data
exec p_upsert_major @major_code='CSC',@major_name='Computer Science and' ,@major_id='4'
exec p_upsert_major @major_code='FIN',@major_name='Finance' ,@major_id='6'

-- Verify
select * from dbo.majors



--2.a
--ID:hli248
--DOWN
drop function if EXISTS f_concat
go
-- UP Metadata
create function f_concat(
    @a varchar(50),
    @b varchar(50),
    @sep varchar(50)
) returns varchar(150) as begin 
return (@a+@sep+@b)
end 

go
--2.b
--ID:hli248
--DOWN
drop view if exists v_students 
go
--UP
create view v_students as 
select student_id, dbo.f_concat(student_firstname,student_lastname,',') as student_name_first, 
dbo.f_concat(student_lastname,student_firstname,',') as student_name_last, student_gpa,m.major_name from dbo.students
join dbo.majors m on m.major_id=student_major_id
GO

select*from v_students

--3.a
--ID:hli248
select major_id,major_code,major_name,value keyword from dbo.majors
cross apply string_split(major_name,' ') 

--3.b
--ID:hli248
drop function if exists  f_search_majors
go 

create function f_search_majors(
    @major varchar(50)
)returns table as 
return select*from (select major_id,major_code,major_name,value keyword from dbo.majors
cross apply string_split(major_name,' ')) s
where s.keyword=@major
go 

select * from f_search_majors('Science')


--4.a
--ID:hli248
ALTER table dbo.students 
   add student_active char(1) DEFAULT 'Y' not null, student_inactive_date date null
GO

--4.b
--ID:hli248
drop TRIGGER if exists lab10
GO

create TRIGGER lab10 on dbo.students 
after INSERT,UPDATE as BEGIN  
  --  if update (student_inactive_date) begin
    update dbo.students
        set student_active = case 
    when student_inactive_date is null then 'Y'
    else 'N'
   -- end
    end
end

--4.c
--ID:hli248
update dbo.students
set student_inactive_date = '2020-08-01'
where student_year_name = 'Graduate'

--4.d
--ID:hli248
update dbo.students
set student_inactive_date = null
where student_year_name = 'Graduate'

/*
select *from dbo.majors
select *from dbo.students
*/