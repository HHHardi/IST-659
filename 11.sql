--Q1:
--ID:hli248
use tinyu
go

drop PROCEDURE if EXISTS dbo.p_upsert_major
go 

create PROCEDURE dbo.p_upsert_major (
    @major_code char(3),
    @major_name varchar(50)
) as BEGIN
    begin try 
        begin TRANSACTION
        --data logic 
        if exists (select * from majors where major_code=@major_code) BEGIN
            update majors set major_name=@major_name 
                where major_code=@major_code
            if @@ROWCOUNT <> 1 throw 50001,'p_upsert_major: Updata Error', 1
        END
        else begin 
            DECLARE @id int = (select max(major_id) from majors)+ 1
            insert into majors (major_id,major_code,major_name)
                values (@id,@major_code,@major_name)
            if @@ROWCOUNT <> 1 throw 50002, 'p_upsert_major: Insert Error', 1
        end 
        COMMIT
    end TRY
    begin catch 
        ROLLBACK
        ;
        THROW
    end catch
end 
GO

--Q2:
--ID:hli248
select * from majors
EXEC dbo.p_upsert_major @major_code='IS',@major_name='Information System'
go

select * from majors
go

--Q3:
--ID:hli248
--check the procedures
use vbay
go

select  * from sys.procedures
sp_helptext'p_place_bid';
GO

--Q3:
--ID:hli248
drop PROCEDURE if EXISTS dbo.p_place_bid
go 

create procedure dbo.p_place_bid ( 	@bid_item_id int, 	@bid_user_id int, 	@bid_amount money ) 
as begin 	
    begin try
        begin TRANSACTION
            declare @max_bid_amount money 	
            declare @item_seller_user_id int 	
            declare @bid_status varchar(20) 	 	
            -- be optimistic :-) 	
            set @bid_status = 'ok' 	 	
            -- TODO: 5.5.1 set @max_bid_amount to the higest bid amount for that item id  	
            set @max_bid_amount = (select max(bid_amount) from vb_bids where bid_item_id=@bid_item_id and bid_status='ok')  	 	
            -- TODO: 5.5.2 set @item_seller_user_id to the seller_user_id for the item id 	
            set @item_seller_user_id = (select item_seller_user_id from vb_items where item_id=@bid_item_id)   	
            -- TODO: 5.5.3 if no bids then set the @max_bid_amount to the item_reserve amount for the item_id 	
            if (@max_bid_amount is null)  		
                set @max_bid_amount = (select item_reserve from vb_items where item_id=@bid_item_id)  	 	
            -- if you're the item seller, set bid status 	
            if ( @item_seller_user_id = @bid_user_id) 		
                set @bid_status = 'item_seller' 	 	
            -- if the current bid lower or equal to the last bid, set bid status 	
            if ( @bid_amount <= @max_bid_amount) 		
                set @bid_status = 'low_bid' 		 	
            -- TODO: 5.5.4 insert the bid at this point and return the bid_id 

            insert into vb_bids (bid_user_id, bid_item_id, bid_amount, bid_status) 		
                values (@bid_user_id,@bid_item_id, @bid_amount, @bid_status) 	
            COMMIT
            return  @@identity  

        
    end TRY
    begin catch 
        ROLLBACK
        ;
        THROW
    end catch
end 

--Q4:
--ID:hli248
select * from vb_bids where bid_item_id=36
EXEC dbo.p_place_bid @bid_item_id=36, 	@bid_user_id=2, 	@bid_amount=105
go
select * from vb_bids where bid_item_id=36
GO

--Q5:
--ID:hli248
select  * from sys.procedures
sp_helptext'p_rate_user';
go
--Q5:
--ID:hli248
drop PROCEDURE if EXISTS dbo.p_rate_user
go

create procedure dbo.p_rate_user( 	
    @rating_by_user_id int, 	
    @rating_for_user_id int, 	
    @rating_astype varchar(20), 	
    @rating_value int, 	
    @rating_comment text) 
as begin 	
-- TODO: 5.3 	
    begin try
        begin TRANSACTION
            insert into vb_user_ratings (rating_by_user_id, rating_for_user_id, rating_astype, rating_value,rating_comment) 	
            values (@rating_by_user_id, @rating_for_user_id, @rating_astype, @rating_value, @rating_comment) 	
        COMMIT 	
        return @@identity  
    end TRY
    begin catch 
        ROLLBACK
        ;
        THROW
    end catch
end 

--Q6.1:
--ID:hli248
EXEC dbo.p_rate_user	
    @rating_by_user_id=1, 	
    @rating_for_user_id=2, 	
    @rating_astype='Buyer', 	
    @rating_value=6, 	
    @rating_comment='Nice!'

--Q6.2:
--ID:hli248
EXEC dbo.p_rate_user	
    @rating_by_user_id=1, 	
    @rating_for_user_id=1, 	
    @rating_astype='Buyer', 	
    @rating_value=3, 	
    @rating_comment='Emmmm...Good'
go
--Q7:
--ID:hli248
use tinyu
go

drop trigger if exists Q7
go

create trigger Q7
	on students
	instead of update, insert as
begin
declare @flag int=9999
if exists(select student_major_id from (select student_major_id, count(student_major_id) as num from students group by student_major_id) s where num=15)
begin
    set @flag = (select student_major_id from (select student_major_id, count(student_major_id) as num from students group by student_major_id) s where num=15)
end
	if exists(select student_major_id from inserted where student_major_id=@flag) 
	begin
		; --huh? This is required because you cannot say begin... throw
		THROW 666666, 'No changes permitted, students for this major is full',1

		rollback
    end
    else begin 
    update students set students.student_major_id= inserted.student_major_id,
    students.student_year_name= inserted.student_year_name,
    students.student_gpa= inserted.student_gpa
		from inserted
		where students.student_firstname= inserted.student_firstname and students.student_lastname=inserted.student_lastname
    end
end

go

--Q8.1:
--ID:hli248
insert into students
    (student_firstname,student_lastname,student_year_name,student_major_id,student_gpa,student_notes,student_active,student_inactive_date)
    values
    ('Hongdi','Li','Graduate',2,4.00,'Superstar','Y',NULL)

--Q8.2:
--ID:hli248
update students
set student_major_id=2 where student_id=1


