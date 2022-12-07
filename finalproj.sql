/*
---- IST-659
---- Final Project
---- Group 2

┌--Program structure
|
|-------- Create Database
|
|-------- DOWN
|
|-------- UP Metadata
|           |------ Administrators
|           |------ Subscribers
|           |------ Articles
|           |------ Comments
|           |------ Tags
|           |------ Article_tag
|           |------ Friends
|           |------ FKeys
|
|-------- UP Data
|           |------ Insert Administrators
|           |------ Insert Subscribers
|           |------ Insert Articles
|           |------ Insert Comments
|           |------ Insert Tags
|           |------ Insert Article_tag
|           |------ Insert Friends
|           |------ Insert FKeys   
|
|-------- Verify
|
|-------- Functions
|           |------ Find the lasted article (top 5)
|           |------ Find the most popular article by thumb(top5)
|           |------ Find the most popular article by comments(top5)
|           |------ search by related tags(top5)
|
|-------- Procedure
|           |------ Procedure in Administrator
|           |------ Procedure in Subscribers
|
|-------- Trigger
|           |------ Password upper letter check 
|
└-------- Test Case

*/



/*----- Create Database -----*/

if not exists (select * from sys.databases where name='finalproj')
	create database finalproj
GO

use finalproj
GO



/* ---------- DOWN ----------*/
drop trigger if exists proj_2
go

drop trigger if exists proj_1
go

drop PROCEDURE if EXISTS dbo.p_sub_in
go

drop PROCEDURE if EXISTS dbo.p_admin_in
go


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_tags_administrators')
    alter table tags drop CONSTRAINT fk_tags_administrators 


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_article_tag_articles')
    alter table article_tag drop CONSTRAINT fk_article_tag_articles

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_article_tag_tags')
    alter table article_tag drop CONSTRAINT fk_article_tag_tags


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_articles_administrators')
    alter table articles drop CONSTRAINT fk_articles_administrators


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_comments_articles')
    alter table comments drop CONSTRAINT fk_comments_articles

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_comments_userid')
    alter table comments drop CONSTRAINT fk_comments_userid


if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_subscribers_friends_userid_2')
    alter table friends drop CONSTRAINT fk_subscribers_friends_userid_2

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_subscribers_friends_userid_1')
    alter table friends drop CONSTRAINT fk_subscribers_friends_userid_1


drop table if EXISTS friends 
drop table if EXISTS article_tag
drop table if EXISTS tags
drop table if EXISTS comments
drop table if EXISTS articles
drop table if EXISTS subscribers
drop table if EXISTS administrators



/* ------ UP Metadata ------*/

--Administrators
create table administrators(
    admin_id int identity not NULL,
    admin_username varchar(50) not null,
    admin_passwords varchar(50) not null,

    CONSTRAINT pk_admin_id PRIMARY KEY(admin_id),
    CONSTRAINT u_admin_username UNIQUE (admin_username)
)

--Subscribers
create table subscribers(
    sub_userid int identity not null,
    sub_username varchar(50) not null,
    sub_passwords varchar(50) not null,
    sub_email_address varchar(50) not null,
    sub_social_media varchar(50) not null,
    sub_is_blocked int not null default '0',

    CONSTRAINT pk_userid PRIMARY KEY(sub_userid),
    CONSTRAINT u_social_media UNIQUE (sub_social_media),
    CONSTRAINT u_username UNIQUE (sub_username),
    CONSTRAINT u_email_address UNIQUE (sub_email_address)
)

--Articles
create table articles(
    article_id int IDENTITY not null,
    article_name varchar(50) not null,
    article_content varchar(255) not null,
    article_publish_date date not null,
    article_created_by int not null,
    article_is_open int not null default '1',
    article_is_commentable int not null default '1',
    article_thumb int not null default '0',
    article_dislike int not null default '0',

    CONSTRAINT pk_article_id PRIMARY KEY(article_id)
)

--Comments
create table comments(
    comment_id int IDENTITY not null,
    comments_article_id int not null,
    comments_create_by int not null,
    comments_create_date date not null,
    comments_thumb int not null default '0',
    comments_dislike int not null default '0',
    commemt_state int not null default '1',

    CONSTRAINT pk_comment_id PRIMARY KEY(comment_id,comments_article_id)
)


--Tags
create table tags(
    tag_id int IDENTITY not null,
    tag_name varchar(50) not null,
    tag_description varchar(50) not null,
    tag_state int not null default '1',
    tag_created_by int not null,
    tag_created_date date not null,

    CONSTRAINT pk_tag_id PRIMARY KEY(tag_id),
    CONSTRAINT u_tag_name UNIQUE (tag_name),
    CONSTRAINT u_tag_description UNIQUE (tag_description)
)

--Article_tag
create table article_tag(
    a_article_id int not null,
    a_tag_id int not null,

    CONSTRAINT pk_a_article_id PRIMARY KEY(a_article_id,a_tag_id)
)


--Friends
create table friends(
    id_1 int not null,
    id_2 int not null,
    friend_is_accepted int not null DEFAULT '0',
    --0 is not accepted, 1 is accepted
    friend_last_update date not null,

    CONSTRAINT pk_id_list PRIMARY KEY(id_1,id_2)
)

--FKeys
alter table friends
    add CONSTRAINT fk_subscribers_friends_userid_1 foreign key (id_1)
        REFERENCES subscribers(sub_userid)

alter table friends
    add CONSTRAINT fk_subscribers_friends_userid_2 foreign key (id_2)
        REFERENCES subscribers(sub_userid)


alter table comments
    add CONSTRAINT fk_comments_userid foreign key (comments_create_by)
        REFERENCES subscribers(sub_userid)

alter table comments
    add CONSTRAINT fk_comments_articles foreign key (comments_article_id)
        REFERENCES articles(article_id)


alter table articles
    add CONSTRAINT fk_articles_administrators foreign key (article_created_by)
        REFERENCES administrators(admin_id)


alter table article_tag
    add CONSTRAINT fk_article_tag_articles foreign key (a_article_id)
        REFERENCES articles(article_id)

alter table article_tag
    add CONSTRAINT fk_article_tag_tags foreign key (a_tag_id)
        REFERENCES tags(tag_id)


alter table tags
    add CONSTRAINT fk_tags_administrators foreign key (tag_created_by)
        REFERENCES administrators(admin_id)



/*---------- UP Data ----------*/

--insert administrators 
insert into administrators 
(admin_username,admin_passwords) 
values 
('hli248','SUsuhli248!'),
('fanbingbing','lovehardi1314@'),
('KanyeWest','Nikeisgood999!')

--insert subscribers
insert into subscribers
(sub_username,sub_passwords,sub_social_media,sub_email_address)
VALUES
('Chunyu','LGDChunyucy#','AME_AME','cy111@syr.edu'),
('Chao','RNGxiaoke1121$','Maybe_Xiaoke','chao22@syr.edu'),
('Rick','Rick&mortyyeah#','Dr_Rick','R&M11327@gmail.com'),
('Oliver','oliverisoliver123$','NB_Oliver','oli82@syr.edu')

--insert articles
insert into articles
(article_name,article_publish_date,article_created_by,article_thumb,article_dislike,article_content)
VALUES
('Database study','2017-12-11',1,999,0,'I love IST-659...'),
('How to study SQL?','2020-6-18',1,998,0,'Go to github, watch and learn...'),
('Actor and money','2021-6-18',2,178,150,'I earned 700k dollars in movie....'),
('To be were not to be?','2021-10-10',3,500,50,'That is not a problem, since I...'),
('How to become a good rapper?','2021-08-04',3,651,30,'Let us talk about my new mixtape...'),
('Fitness and actor','2020-12-01',2,400,200,'I love running and....'),
('Database and data','2017-12-13',1,997,0,'Different between SQL and ...')

--insert comments
insert into comments
(comments_article_id,comments_create_by,comments_create_date,comments_thumb,comments_dislike,commemt_state)
VALUES
(1,2,'2022-11-11',10,1,0),
(1,1,'2022-11-13',15,6,0),
(1,3,'2022-01-15',1,2,0),
(2,4,'2022-06-14',20,0,1),
(3,4,'2022-09-19',17,13,0),
(4,1,'2022-11-09',150,200,1),
(4,3,'2022-12-05',0,2,0),
(5,4,'2022-02-01',1,6,1)

--insert tags
insert into tags
(tag_name,tag_created_by,tag_created_date,tag_description,tag_state)
VALUES
('DS',1,'2015-01-12','We love study ds and SQL',1),
('Dota2',2,'2021-09-19','We love play Dota2',0),
('FYP',2,'2018-09-19','for you',1),
('R&B',3,'2018-09-18','rap and rap',1),
('BAE',1,'2015-01-13','Best article ever',1),
('DS study',1,'2015-01-13','We love study ds',1),
('DS studnet',1,'2015-01-14','SQL',1)

--insert article_tag
insert into article_tag
(a_article_id,a_tag_id)
VALUES
(1,1),
(1,4),
(2,6),
(3,3),
(4,5),
(5,4),
(6,3),
(7,7)

--insert friends
insert into friends
(id_1,id_2,friend_is_accepted,friend_last_update)
VALUES
(1,2,'1','2021-11-13'),
(1,3,'1','2021-11-13'),
(2,3,'1','2021-10-16'),
(3,4,'1','2022-01-07')



/*------------- Verify ------------*/

--check the whole data
select * from administrators
select * from subscribers
select * from articles
select * from comments
select * from tags
select * from article_tag
select * from friends



/*----------- Functions ----------*/

--Find the lasted article (top 5)
select TOP 5 a.article_publish_date,a.article_name, d.admin_username,a.article_content from articles a 
join administrators d on a.article_created_by=d.admin_id
where article_is_open=1
order by article_publish_date DESC 


--Find the most popular article by thumb(top5)
select top 5 a.article_thumb, a.article_name, d.admin_username,article_content from articles a 
join administrators d on a.article_created_by=d.admin_id
where article_is_open=1
order by article_thumb DESC 


--Find the most popular article by comments(top5)
select TOP 5 a.article_name,d.admin_username,a.article_content,count(c.comments_article_id) as comment_num from articles a 
join comments c on c.comments_article_id=a.article_id 
join administrators d on a.article_created_by=d.admin_id
where c.commemt_state=1 and a.article_is_open=1 and a.article_is_commentable=1
group by a.article_name,d.admin_username,a.article_content
order by comment_num DESC


--search by related tags(top5)
--Example of search by tag name like DS, eg. DS, DS study, DS student
select t.tag_name,a.article_name, d.admin_username,article_content from articles a 
join administrators d on a.article_created_by=d.admin_id
join article_tag ta on ta.a_article_id=a.article_id
join tags t on t.tag_id=ta.a_tag_id
where a.article_is_open=1 and t.tag_name like 'DS%'
go



/*----------- Procedure -----------*/

--Procedure in Administrator
create procedure dbo.p_admin_in( 	
    @admin_username varchar(50),
    @admin_passwords varchar(50)
)
as begin 
    if @admin_username is null begin
        RAISERROR (15600,-1,-1,'username cannot be null'); 
    end
    else if @admin_passwords is null begin 
        RAISERROR (15600,-1,-1,'passwords cannot be null'); 
    end
    --To make sure insert data is not null
    ELSE begin
    begin try
        begin TRANSACTION
            insert into administrators (admin_username, admin_passwords) 	
            values (@admin_username,@admin_passwords) 	
        COMMIT 	
        return @@identity  
    end TRY
    begin catch 
        ROLLBACK
        ;
        THROW
    end catch
    end
end 
go


--Procedure in Subscribers
create procedure dbo.p_sub_in( 	
    @sub_username varchar(50),
    @sub_passwords varchar(50),
    @sub_email_address varchar(50),
    @sub_social_media varchar(50)
)
as begin 
    if @sub_username is null begin
        RAISERROR (15600,-1,-1,'username cannot be null'); 
    end
    else if @sub_passwords is null begin 
        RAISERROR (15600,-1,-1,'passwords cannot be null'); 
    end
    else if @sub_email_address is null BEGIN
        RAISERROR (15600,-1,-1,'email cannot be null'); 
    end
    else if @sub_social_media is null BEGIN
          RAISERROR (15600,-1,-1,'social account cannot be null');
    end
    --To make sure insert data in not null
    ELSE begin
    begin try
        begin TRANSACTION
            insert into subscribers (sub_username,sub_passwords,sub_social_media,sub_email_address) 	
            values (@sub_username,@sub_passwords,@sub_social_media,@sub_email_address) 	
        COMMIT 	
        return @@identity  
    end TRY
    begin catch 
        ROLLBACK
        ;
        THROW
    end catch
    end
end 
GO



/*----------- Trigger -----------*/

--We consider for the account safe that every user's password should at least contains one upper letter
create trigger proj_1
	on administrators
	instead of update,insert as
begin
	if not exists(select admin_passwords from inserted WHERE admin_passwords COLLATE Latin1_General_CS_AS like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%') begin
    ; 
		THROW 666666, 'Password should at least contain an upper letter!',1
		rollback
    end
    else begin 
        update administrators set administrators.admin_username=inserted.admin_username,
        administrators.admin_passwords=inserted.admin_passwords from inserted
        where administrators.admin_username=inserted.admin_username and administrators.admin_passwords=inserted.admin_passwords
    end
end

go

create trigger proj_2
	on subscribers
	instead of update,insert as
begin
	if not exists(select sub_passwords from inserted WHERE sub_passwords COLLATE Latin1_General_CS_AS like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%') begin
    ; 
		THROW 666666, 'Password should at least contain an upper letter!',1
		rollback
    end
    else begin 
        update subscribers set subscribers.sub_username=inserted.sub_username,
        subscribers.sub_passwords=inserted.sub_passwords,
        subscribers.sub_email_address=inserted.sub_email_address,
        subscribers.sub_social_media=inserted.sub_social_media from inserted
        where subscribers.sub_username=inserted.sub_username and subscribers.sub_passwords=inserted.sub_passwords
    end
end
GO



/*------------ Test Case ------------*/

----Try insert ZhengyuWang and it work (Procedure check data is good )
exec dbo.p_admin_in
    @admin_username='ZhengyuWang',
    @admin_passwords='WZY12345@@#'
----To check 
select * from administrators
go


----Try insert Pudge and it cant work (Procedure check the password is null)
exec dbo.p_sub_in
    @sub_username='Pudge',
    @sub_passwords=null,
    @sub_email_address='Pudge@gamil.com',
    @sub_social_media='Pudge_love_meat'
----To check 
select * from subscribers
go

----Try insert Masiwei and it cant work (trigger check the password does not contain upper letter)
insert into administrators
(admin_username,admin_passwords)
VALUES
('Masiwei','masiweiblackhorse')
----To check
select * from administrators

----Try insert Nezuko and it cant work (trigger check the password does not contain upper letter)
insert into subscribers
(sub_username,sub_passwords,sub_social_media,sub_email_address)
VALUES
('Nezuko','nezuko1231','NEzuko_DemonSlayer','nezukoDS@yahoo.com')
----To check
select * from subscribers

