/*
select item_name, item_type, item_reserve, item_soldamount
    from vb_items
    where item_type='Collectables'
    order by item_name
*/

/*
select s.user_email, s.user_firstname, s.user_lastname, i.item_type, i.item_name
    from vb_items i 
        join vb_users s on i.item_seller_user_id=s.user_id
    where i.item_type='Antiques'
*/



/*
--ID: hli248@syr.edu
--Q1:
select user_email, user_firstname, user_lastname
    from vb_users
    where user_zip_code like '13%'
    s.user_email, s.user_firstname, s.user_lastname, z.zip_city, z.zip_code
*/


/*
--ID: hli248@syr.edu
--Q2:
select s.user_email, s.user_firstname, s.user_lastname, z.zip_city, z.zip_code, z.zip_state
    from vb_zip_codes z
        join vb_users s on z.zip_code=s.user_zip_code
    where z.zip_state='NY'
    order by z.zip_city,s.user_lastname,s.user_firstname
*/


/*
--ID: hli248@syr.edu
--Q3:
select item_id,item_name,item_type,item_reserve 
    from vb_items 
    where item_reserve>=250 and item_sold =0
    order by item_reserve DESC
*/


/*
--ID: hli248@syr.edu
--Q4:
select item_id,item_name,item_type,item_reserve, 
    case 
        when item_reserve>=250 then 'high priced'
        when item_reserve<=50 then 'low priced'
        else 'average price'
    END item_reserve_category
    from vb_items
    where item_type != 'All Other'
*/


/*
--ID: hli248@syr.edu
--Q5:
select b.bid_id,s.user_firstname, s.user_lastname,s.user_email, b.bid_datetime,b.bid_amount
    from vb_items i
        join vb_bids b on i.item_id=b.bid_item_id
        join vb_users s on b.bid_user_id=s.user_id
        where b.bid_status='ok' 
    order by b.bid_datetime DESC
*/


/*
--ID: hli248@syr.edu
--Q6:
select b.bid_datetime,s.user_firstname, s.user_lastname,s.user_email, b.bid_user_id,b.bid_id,i.item_name,i.item_id, 
    b.bid_amount,b.bid_status
    from vb_bids b
    join vb_users s on b.bid_user_id=s.user_id
    join vb_items i on i.item_id=b.bid_item_id
        where b.bid_status!='ok' 
    order by s.user_lastname,s.user_firstname,b.bid_datetime 
*/


/*
--ID: hli248@syr.edu
--Q7:
select i.item_id,i.item_name, i.item_type, s.user_firstname,s.user_lastname,i.item_reserve
    from vb_items i
        left join vb_bids b on i.item_id=b.bid_item_id
        join vb_users s on i.item_seller_user_id=s.user_id
        where b.bid_item_id is NULL
*/


/*
--ID: hli248@syr.edu
--Q8:
select s.user_firstname +' '+ s.user_lastname as rating_by, 
    s_1.user_firstname +' '+ s_1.user_lastname as rating_for, r.rating_value,r.rating_comment
    from vb_user_ratings r 
    join vb_users s on r.rating_for_user_id=s.user_id 
    join vb_users s_1 on r.rating_by_user_id=s_1.user_id 
    where r.rating_astype='Seller'
*/

/*
--ID: hli248@syr.edu
--Q9:
select i.item_id,i.item_name,i.item_type,i.item_soldamount,
    s_1.user_firstname+' '+s_1.user_lastname as buyer_name,
    z_1.zip_state as buyer_state, z_1.zip_city as buyer_city,
    s_2.user_firstname+' '+s_2.user_lastname as seller_name,
    z_2.zip_state as seller_state, z_2.zip_city as seller_city
    from vb_items i
    join vb_users s_1 on i.item_buyer_user_id=s_1.user_id
    join vb_users s_2 on i.item_seller_user_id=s_2.user_id
    join vb_zip_codes z_1 on s_1.user_zip_code=z_1.zip_code 
    join vb_zip_codes z_2 on s_2.user_zip_code=z_2.zip_code 
where i.item_sold=1
*/

--ID: hli248@syr.edu
--Q10:
select s.user_firstname+ ' '+s.user_lastname as no_activity_name,s.user_email 
    from vb_users s
    left join vb_bids b on s.user_id=b.bid_user_id
    left join vb_items i on s.user_id=i.item_buyer_user_id and s.user_id=i.item_seller_user_id
    where b.bid_user_id is null and i.item_seller_user_id is null and i.item_buyer_user_id is null
    
