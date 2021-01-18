#182. Duplicate Emails
select email from person group by email having count(*)>1;

#511. Game Play Analysis
select player_id, min(event_date) as first_login
from activity group by player_id;

#578. Highest answer rate
-- Note: answer rate = answer actions / total non-answer actions--
select question_id from suervey_log
group by survey_od 
order by count(answer_id)/(count(*)-count(answer_id)) desc
limit 1;
                                           
#584. Find Customer Referee
select name from customer where referee!=2 or referww_id is Null;
########################
select name from customer where isnull(referee_id,0)!=2;
########################                                         
select name from customer where coalesce(referee_id,0)!=2;

#586. Largest Number of orders
select customer_number from orders group by customer_number order by count(*) desc limit 1;
                                          
                                          
#595. Big Countries
SELECT name, population, area
                                          
FROM World
WHERE area > 3000000 OR population > 25000000;
                                          
#596. Classes with more than 5 students
select class from courses group by class having count(distinct student) >=5;
                                          
#619. Biggest single number
select max(num) as num from
   (select num from my_numbers group by num having count(*)=1) tmp;                                          
                                          
#620. Not boring Movie                                         
select * from cinema where id%2=1 and description!='boring'
order by rating desc;                                          
                                          
#1050. Collaborate more than 3 times                                          
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;                                          
                                          
#1069. Products Sales                                          
SELECT product_id, SUM(quantity) AS total_quantity
FROM Sales
GROUP BY product_id;
                                         
#1076. Project Employees - Top 1 with Ties (multiple top 1)
select project_id
from (select * , rank() over (order by tmp1.num) as rank from 
      (select project_id, count(distinct employee_id) as num 
       from project 
       group by project_id ) tmp1
       ) tmp2                             
where rank=1 ;                                         
###########################
select project_id
from Project
group by project_id
having count(employee_id) >= (
  select count(employee_id) as cnt
  from Project
  group by project_id
  order by cnt desc
  limit 1
);
                                          
                                          
#1082. Products Sales - Top 1 with Ties (Different method from #1076)                                          
select seller_id from sales group by seller_id
having sum(price) in  
                   (select sum(price) from sales group by seller_id order by sum(price) desc limit 1);
#################################
 select seller_id
 from Sales
 group by seller_id
 having sum(price) >= all(
                      select sum(price)
                      from Sales
                      group by seller_id );     
                                          
                                          
#1141. Num of User activity for the past 30 days
select activity_date as day, count(distinct user_id) as active_users
from activity
group by day                                          
having  day between date_sub("2019-07-27", INTERVAL 29 DAY)  and '2019-07-27';                                       
                                          
#1148. Article Views - Authors view their own articles
select distinct author_id as id
from views
where author_id=viewer_id
order by id;                                          
                                          
#1149. Article Views - Viewers who review more than one article per day.                                          
select distinct viewer_id as id
from views
group by viewer_id, viewer_date
having count(distinct article_id)>1
order by id;                                          
                                          
