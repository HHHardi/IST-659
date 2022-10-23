/*
--ID:hli248@syr.edu
--Q1:
select  s.user_firstname+' '+s.user_lastname as name,z.zip_lat,z.zip_lng
    from vb_users s
        join vb_zip_codes z on s.user_zip_code=z.zip_code
        join vb_bids b on s.user_id=b.bid_user_id
        where b.bid_status = 'OK'
*/

/*
--ID:hli248@syr.edu
--Q2:
select LastName+' '+FirstName as ContactName,Title,  'Northwind' as CompanyName, Address, City, Country, Region, PostalCode
    from Employees
    UNION
select ContactName, ContactTitle as Title,CompanyName,Address,City,Country, Region, PostalCode
    from Customers
    UNION
select ContactName, ContactTitle as Title,CompanyName,Address,City,Country, Region, PostalCode
    from Suppliers
*/

/*
--ID:hli248@syr.edu
--Q3:
with new as(
    select i.item_id, i.item_name, i.item_type, b.bid_status 
    from vb_items i 
    join vb_bids b on b.bid_item_id=i.item_id
)
select * from new 
pivot(
    count(bid_status) for bid_status in (ok,low,item_seller)
) p_new 
*/

/*
--ID:hli248@syr.edu
--Q4:
with new_1 as (
    select c.CustomerID, c.CompanyName, o.Freight, s.CompanyName as shipper
        from Customers c 
        join Orders o on o.CustomerID=c.CustomerID
        join Shippers s on o.ShipVia=s.ShipperID
)
select * from new_1
pivot(
    sum(Freight) for Shipper in ("Federal Shipping", "Speedy Express","United Package")
) p_new_1 
*/

/*
--ID:hli248@syr.edu
--Q5:
select OrderID, Date, [Type of date] from Orders
UNPIVOT(
    Date for [Type of date] in (ShippedDate,RequiredDate,OrderDate)
) p_new_2
*/


/*
--ID:hli248@syr.edu
--Q6:
select title_name, format
    from ff_titles
    
UNPIVOT(
    where_1 for format in (title_bluray_available,title_dvd_available,title_instant_available)
) p_new_3
where title_type='Movie' and where_1=1
*/

/*
--ID:hli248@syr.edu
--Q7:
select * from employees for
    system_time as of '2018-05-31'
*/

--ID:hli248@syr.edu
--Q8:
select a.employee_id, a.employee_ssn, a.employee_firstname+' '+a.employee_lastname as name,a.employee_pay_rate as [pay rate], a.employee_pay_rate as [previous pay rate],
a.employee_pay_rate-b.employee_pay_rate as diff, b.employee_pay_rate as [pay increas]
    from employees_history a 
join employees_history b on a.valid_from=b.valid_to 
where a.employee_firstname+' '+a.employee_lastname='Gus Toffwind' 

