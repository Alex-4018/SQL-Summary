#1. The customer who bought the most units on each day 
select order_day, customer_id;
from (
      select order_day,customer_id,dense_rank() over (partition by order_day order by sum(quantity_sold) desc) r
      from orders group by order_day,customer_id
      ) x
where r=1;

#2. Employees in the invalid department
select employee_id from employee as e left join department as d 
on e.department_id=d.department_id
where department_name is Null;
##################################
select employee_id from employee e
where not exist (
select * from  department d where e.department_id=d.department_id) ;


#3. Pivot 
select department_id,
case when month='Jan' then sum(revenue) end as Jan_Revenue,
case when month='Feb' then sum(revenue) end as Feb_Revenue,
...
from department
group by department_id;

#4. Trailing 7 days Sum
select a.date, a.device, sum(b.answer) from table a join table b 
on a.device=b.device and (a.date-b.date between 0 and 6)
group by a.date, a.device;
################################
select date, device, sum(answer) over (partition by device order by date rows between 6 preceding and current row) from table;

#5. Top Three books sold in each city, during the last 3 month 
select city, books, r 
from (
      select city, books,dense_rank() over (partition by city order by sum(quantity) desc) as r
      from table where order_date>= date_sub(current_date,, INTERVAL 3 month))
where r <=3;
###############################
With sales as 
(select city, books, sum(quantity) as quantity from table group by city,book where order_date>= date_sub(current_date,, INTERVAL 3 month))    
select * from sales s1 where (select count(distinct s2.quantity) from sales s2 where s2.quantity>s1.quantity and s1.city=s2.city)<3;
                                                                                                         
#6. Sum for by month and week 
select date_format(date, '%Y-%m') as month, ceiling (right(date,2)/7) as week_num, count(orderitems_id)  
from orders group by month, week_num;
                                                                                                         
#7. Num of customers who purchased both Alexa and Kindle
select count(distinct customer_id) 
from (select customer_id  from orders as t1 left join order_item as t2 on t1.order_id=t2.order_id join items i on i.item_id=t2.item_id
      where i.order_name='Alexa') a 
      inner join 
     (select customer_id  from orders as t3 left join order_item as t4 on t3.order_id=t4.order_id join items i on i.item_id=t4.item_i
      where i.order_name='Kindle') b
      on a.customer_id=b.customer_id;                        
                            
#8. Customers bought all types of products in Y table
select customer_id
from x inner join y on x.pro_key=y.pro_key
group by x.customer_id
having count(distinct x.pro_key)=(select count(distinct y.pro_key) from y);
                                                                                                         
                                                                                                         
#9. Actors who collaborate with director more than 3 times                                                                                                         
select actor
from table 
group by actor,director
having count(date)>=3;


#10. Find Block or Suspend seller after 'reinsate'
select seller_id
from table 
group by seller_id                                                                                                         
having max(case when status !='reinstate' then date end)>max(case when status='reinstate' then date end);
###########################################
With reinstate as                                                                                                         
(select seller_id, max(date) as date
from table
group by seller_id
where status='reinstate')
select distinct seller_id
from table inner join reinstates                                                                                                         
on table.seller_id=reinstates.seller_id and table.date>reinstate.date
where status in ('block','suspend') ;                                                                                                        
                                                                                                         
                                                                                                                                                                                                               
#11. First status after latest reinstate
With reinstate as                                                                                                         
(select seller_id, max(date) as date
from table
group by seller_id
where status='reinstate')                                                                                        
select distinct seller_id, first_value(status) over (partition by seller_id order by date) as first_status
from table t inner join reinstate r on t.seller_id=r.seller_id and t.date>r.reinstate_date;                                                                                                        
################################################################
with next as
(select *, lead(status,1) over (partition by seller_id order by date) as next_status
from table),
reinstate as                                                                                                         
(select seller_id, max(date) as date
from table
group by seller_id                                                                                                         
select  distinct seller_id, next_status
from next inner join reinstate on next.seller_id=reinstate.seller_id and next.date=reinstate.date
where status='reinstate';                                                                                                         
                                                                                                         

#12. Customers who bought A in 2010 and B in 2018
select distinct id from t t1, t t2 where t1.id=t2.id and t1.product=A and year(t1.date)=2010 and t2.product=B and year(t2.date)=2018;
###################################################
select id 
from rable 
where (year(date)=2010 and product=A) 
or (year(date)=2018 and product=B) 
group by id 
having count (distinct year(date))=2; 
###############################################
Select distinct id from table t1
where year(date) = 2010 and product = A and 
      exists (select * from table t2 where year(date) = 2018 and product = B and t1.id = t2.id); 
                                                                                                         
#13. Combination of unique depature and arrival flight (???)                                                                                                        
SELECT DISTINCT 
CASE WHEN departure > arrival THEN arrival ELSE departure AS departure, 
CASE WHEN departure > arrival THEN departure ELSE arrival AS arrival 
FROM flight 
                                                                                                         
#14. Percentage of Cusomer orders by date and category
select date, category, 100*count(c.order_id)/count(o.order_id) as pctg
from order o left join 
     (select * from customer where customer.type='first') c on o.order_id=c.order_id
group by date, category;
                                                                                                         
#15. The most favorate first-time-watch movie
select table.title from table 
           inner join (select customer_id, min(date) from table group by customer_id) x 
           on table.customer_id=x.customer_id and table.date=x.date
group by table.title
order by count(t.customer_id) desc limit 1;
#######################################                                                                                                         
With first_movie as 
(select *, rank() over (partition by customer_id order by date) as r from table where r=1)
select title from first_movie group by title order by count(customer_id) desc limit 1;
                                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
                                                                                                         
