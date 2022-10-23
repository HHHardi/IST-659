if not exists(select * from sys.databases where name='lab8')
    create database lab8
GO

use lab8
-- DOWN
--hli248
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_customer_address_a_id')
    alter table customer_addresses drop CONSTRAINT fk_customer_address_a_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME='fk_customer_address_c_id')
    alter table customer_addresses drop CONSTRAINT fk_customer_address_c_id

drop table if exists customer_addresses
drop table if exists addresses
drop table if exists customers
-- UP Metadata
--hli248
create table customers (
    customer_id int IDENTITY not NULL,
    customer_email varchar(50) not NULL,
    customer_fistname varchar(50) not NULL,
    customer_lastname varchar(50) not NULL,

    CONSTRAINT pk_customer_id primary key (customer_id),
    CONSTRAINT u_customer_email UNIQUE (customer_email)
)

create table addresses(
    address_id int IDENTITY not NULL,
    primary_street varchar(50) not null,
    secondary_street varchar(50),
    city varchar(50) not null,
    region varchar(50) not null,
    postal_code varchar(50) not null,
    country varchar(50) not null,

    CONSTRAINT pk_address_id PRIMARY key(address_id)  
)

create table customer_addresses (
    customer_id int not NULL,
    address_id int not NULL,
    address_type varchar(50),

    CONSTRAINT pk_customer_address_id primary key (customer_id,address_id)
)
alter table customer_addresses
    add CONSTRAINT fk_customer_address_c_id FOREIGN key (customer_id)
        REFERENCES customers(customer_id)
alter table customer_addresses
    add CONSTRAINT fk_customer_address_a_id FOREIGN key (address_id)
        REFERENCES addresses(address_id)
-- UP Data
--hli248
insert into customers
    (customer_email,customer_fistname,customer_lastname)
    values
    ('hli248@syr.edu','Hongdi','Li'),
    ('123@syr.edu','Hardi','Li'),
    ('345@syr.edu','HHH','Lee')

insert into addresses
    (primary_street,secondary_street,city,region,postal_code,country)
    VALUES
    ('119 diana ave',NULL,'Syracuse','NY','13210','US'),
    ('2120 cowell blvd','111 apt','Davis','CA','95618','US'),
    ('10095 colima rd',NULL,'LA','CA','94536','US')

insert into customer_addresses
    (customer_id,address_id,address_type)
    values
    (1,1,'type-c'),
    (2,2,'type-b'),
    (3,3,'type-1')


-- Verify
--hli248
select * from customers 
select * from addresses
select * from customer_addresses
