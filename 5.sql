/*
select * from vb_items
select * from vb_bids
*/

/*
select *
    from vb_items
        join vb_bids on item_id=bid_item_id
    where bid_status='ok'
*/

/*
select item_name, item_reserve,min(bid_amount) as min_bid, max(bid_amount) as max_bid, item_soldamount
    from vb_items
        join vb_bids on item_id=bid_item_id
    where bid_status='ok'
    group by item_name, item_reserve, item_soldamount
    order by item_reserve DESC
*/

/*
select *
    from vb_users s
        left join vb_bids b 
            on b.bid_user_id=s.user_id
    where b.bid_status='ok'
    --group by s.user_email, s.user_firstname, s.user_lastname
*/

/*
select s.user_email,s.user_firstname,s.user_lastname, count(*) as bids_counts
    from vb_users s
        left join vb_bids b 
            on b.bid_user_id=s.user_id
    where b.bid_status='ok'
    group by s.user_email, s.user_firstname, s.user_lastname
*/

/*
select s.user_email,s.user_firstname,s.user_lastname, count(*) as bids_counts,
    case when count(*) BETWEEN 0 and 1 then 'Low'
        when count(*) between 2 and 4 then 'Moderate'
        else 'High' end as user_bid_activity
    from vb_users s
        left join vb_bids b 
            on b.bid_user_id=s.user_id
    where b.bid_status='ok'
    group by s.user_email, s.user_firstname, s.user_lastname
*/


/*
with user_bids as(
    select s.user_email,s.user_firstname,s.user_lastname, count(*) as bids_counts,
        case when count(*) BETWEEN 0 and 1 then 'Low'
            when count(*) between 2 and 4 then 'Moderate'
            else 'High' end as user_bid_activity
        from vb_users s
            left join vb_bids b 
                on b.bid_user_id=s.user_id
        where b.bid_status='ok'
        group by s.user_email, s.user_firstname, s.user_lastname
)
select user_bid_activity, count(*) as user_count
    from user_bids
    group by user_bid_activity  
    order by user_count
*/

/********************************************************************************************************************************************************/

/*
--ID:hli248
--Q1:
select item_type, min(item_reserve) as min_reserve,max(item_reserve) as max_reserve,avg(item_reserve) as avg_reserve, count(item_type) as item_sum
    from vb_items
    group by item_type
    order by item_type 
*/

/*
--ID:hli248
--Q2:
select item_name, item_type, item_reserve, min(item_reserve) as min_reserve,max(item_reserve) as max_reserve,avg(item_reserve) as avg_reserve
    from vb_items
    where item_type='Antiques' or item_type='Collectables'
    group by item_name, item_type, item_reserve
*/

/*
--ID:hli248
--Q3:
select s.user_firstname +' '+ s.user_lastname as name,count(*) as number_of_rating,avg(cast(rating_value as decimal(10,3))) as avg_rating
    from vb_user_ratings r 
    join vb_users s on r.rating_for_user_id=s.user_id 
    where r.rating_astype='Seller'
    group by s.user_firstname,s. user_lastname
*/

/*
--ID:hli248
--Q4:
with c_item_bid as(
select i.item_name, count(*) as sum_of_bids
     from vb_items i
        join vb_bids b on i.item_id=b.bid_item_id
        where i.item_type='Collectables' 
        group by i.item_name
)

select * from c_item_bid
where sum_of_bids>1
order by sum_of_bids desc
*/

/*
--ID:hli248
--Q5:
select i.item_name,i.item_id,  RANK() OVER (ORDER BY b.bid_amount) bid_order , b.bid_amount, s.user_firstname+' '+ s.user_lastname as bidder
    from vb_bids b
    join vb_users s on b.bid_user_id=s.user_id
    join vb_items i on i.item_id=b.bid_item_id
        where b.bid_status='ok' and item_id='11'
*/

/*
--ID:hli248
--Q6:
select i.item_name,i.item_id,  RANK() OVER (ORDER BY b.bid_amount) bid_order , b.bid_amount,
 lag(s.user_firstname+' '+ s.user_lastname) over (ORDER BY b.bid_amount) prev_bidder,
 s.user_firstname+' '+ s.user_lastname as bidder,
 lead(s.user_firstname+' '+ s.user_lastname) over (ORDER BY b.bid_amount) prev_bidder
    from vb_bids b
    join vb_users s on b.bid_user_id=s.user_id
    join vb_items i on i.item_id=b.bid_item_id
        where b.bid_status='ok' and item_id='11'
*/

/*
--ID:hli248
--Q7:
with test_rating as(
    select s.user_firstname +' '+ s.user_lastname as name,s.user_email,avg(cast(rating_value as decimal(10,3))) over () as avg_rating, r.rating_value,
    count(r.rating_by_user_id) as num_of_rating
        from vb_user_ratings r 
        join vb_users s on r.rating_for_user_id=s.user_id 
        where r.rating_by_user_id is not null
        group by s.user_firstname,s. user_lastname,s.user_email,r.rating_value
)
select * FROM test_rating
    where rating_value<avg_rating and num_of_rating>1
*/

/*
--ID:hli248
--Q8:
select s.user_firstname+' '+s.user_lastname as name,s.user_email ,
    count(*) as total_bid, count(distinct bid_item_id) as total_item,
    cast(count(*) as decimal(10,3))/cast(count(distinct bid_item_id) as decimal (10,3)) as KPI
    from vb_items i
        join vb_bids b on i.item_id=b.bid_item_id
        join vb_users s on b.bid_user_id=s.user_id
        where b.bid_status='ok'
    group by user_email,user_firstname,user_lastname
*/

/*
--ID:hli248
--Q9:
select distinct FIRST_VALUE(s.user_firstname+' '+ s.user_lastname) over (partition by item_name order by bid_amount desc) as name,
FIRST_VALUE(bid_amount) over (partition by item_name order by bid_amount desc) as highest_bid,
i.item_name
    from vb_bids b
    join vb_users s on b.bid_user_id=s.user_id
    join vb_items i on i.item_id=b.bid_item_id
        where b.bid_status='ok' and item_sold=0
*/

--ID:hli248
--Q10:
with test as(
select distinct s.user_firstname +' '+ s.user_lastname as name,count(rating_for_user_id) over(partition by rating_for_user_id) as number_of_rating,
avg(cast(rating_value as decimal(10,3))) over(partition by rating_for_user_id)as global_avg_rating,
avg(cast(rating_value as decimal(10,3))) over(partition by rating_astype)as avg_rating
    from vb_user_ratings r 
    join vb_users s on r.rating_for_user_id=s.user_id 
    where r.rating_astype='Seller'
)
select name, number_of_rating, global_avg_rating, avg_rating, (avg_rating -global_avg_rating) as diff from test