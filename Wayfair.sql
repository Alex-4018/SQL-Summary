#1. The customer who bought the most units on each day 
select order_day, customer_id;
from (
      select order_day,customer_id,dense_rank() over (partition by order_day order by sum(quantity_sold) desc) r
      from orders group by order_day,customer_id
      ) x
where r=1;

#2. Employees in the invalid department































