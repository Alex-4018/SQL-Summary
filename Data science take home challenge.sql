#1. Time Difference between last and second last action for User
select user_id, unix_timestamp- previous_timestamp as delta_lasttwo
from (select user_id,  unix_timestamp, lag(unix_timestamp,1) over (patition by user_id order by unix_timestamp) as previous_timestamp,
             row_number() over (patition by user_id order by unix_timestamp desc) as order_desc 
      from query_one) tmp
where order_desc=1
order by user_id
limit 5;
      
      
#2.  Percentage of Users Distribution   
select 100*sum(case when T.mobile_user is null then 1 else 0 end)/count(*) as web_only,
       100*sum(case when T.web_user is null then 1 else 0 end)/count(*) as mobile_only,
       100*sum(case when T.web_user is not null and T.mobile_user is not null then 1 else 0 end)/count(*) as 'BOTH'
from
(select distinct m.user_id as mobile_user, w.user_id as web_user from data_mobile m left join data_web w on m.user_id=w.user_id
union all
select distinct m.user_id as mobile_user, w.user_id as web_user from data_mobile m right join data_web w on m.user_id=w.user_id where m.user_id is NULL) T;

#3. Define the moment User become a 'Power User' - Buy the 10th item
select user_id, date
from
    (select *, row_number() over (partition by user_id order by date) row_num from query_three) tmp
where row_num=10
order by user_id;

#4. Two Month Amount Sum
#a. Sum by month
select user_id, sum(transaction_amount) as total amount
from
  (select * from query_four_march
  union all 
  select * from query_four_april) tmp
group by user_id
order by user_id;

#b. Cumulative Sum 
select user_id, date, sum(sum(transaction_amount)) over (partition by user_id order by date) as total_amount
from 
  (select * from query_four_march
  union all 
  select * from query_four_april) tmp
group by user_id,date
order by user_id,date;
##################################
select user_id, date, sum(amount) over (PARTITION by user_id order by date) as total_amount
from 
  (SELECT user_id, date, SUM(transaction_amount) as amount
FROM query_four_march
GROUP BY user_id, date
UNION ALL
SELECT user_id, date, SUM(transaction_amount) as amount
FROM query_four_april
GROUP BY user_id, date) tmp
order by user_id,date;

#5. Find Average and Median
SET sql_mode = 'NO_UNSIGNED_SUBTRACTION';
select avg(transaction_amount) as average,
       Avg(Case when row_num_desc-row_num_asc between -1 and 1 then transaction_amount else NULL end) as Median
from
 (select transaction_amount, row_number() over(order by transaction_amount) as row_num_asc,
         count(*) over() -row_number() over(order by transaction_amount) as row_num_desc
   from query_five_users a
   join (select *, date(transaction_date) as date_only from query_five_transactions) b
   on a.user_id=b.user_id and a.sign_up_date=b.date_only) tmp ;
  
#6. Largest and smallest
#a. Country with largest and smallest # of users
select country, tmp.user_count
from 
   (select *, row_number() over (order by a.user_count) as count_asc,
              row_number() over (order by a.user_count desc) as count_desc
       from
      (select  country, count(distinct user_id) as user_count from query_six group by country) a) tmp
where count_desc=1 or count_asc=1;


#b. 
select country, user_id,created_at 
from
  (select *,row_number() over(partition by country order by created_at) count_asc,
            row_number() over(partition by country order by created_at desc) count_desc
   from query_six) tmp
where  count_desc=1 or count_asc=1;



   


















