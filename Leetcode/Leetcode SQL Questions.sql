Basic
###########################################################################
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
                                          
SQL Command
###########################################################################
#196. Delete Duplicate emails                                          
Delete p1
from person p1 join person p2
on p1.id>p2.id and p1.email=p2.email;                                          
##########################
delete from person
where id not in  (select min(id) as id from person group by email);                                  
                                                                                                                        
#627. Swap Salary        
update salary
set sex= (case when sex='m' then 'f' else 'm' end);
                                     
                                          
Simple Join
###########################################################################                                          
#175. Combine two tables
select p.firstname,p.lastname,a.city,a.state
from person p left joion address a on p.person_id=a.person_id;
                                         
#181. Employee earning higher than managers
select e1.name as Employee
from employee e1
join employee e2
on e1.manager_id=e2.id
where e1.salary>e2.salary;
                                          
#183. Customer Never order
select c.name as Customer
from customers c left join orders o on c.id=o.id where o.id is NULL;
##########################################
select name as customer from customers where id not in (select customerid from orders);

                                          
#184. Employee in each Department with highest salary
With max_salary as
(select department_id, max(salary) as max_salary from employee group by department_id)                                          
select d.name department, e.name employee, e.salary 
from max_salary ms join employee e on ms.department_id=e.department_id and ms.salary=e.salary
join department d on e.department_id=d.id;   
###############################################
select department, employee, salary
from (select d.name department, e.name employee, salary, dense_rank() over(partition by departmentid order by salary desc) r
       from employee e join department d on e.departmentid=d.id) tb1
where r=1;

					  

#197. Rising Temperature
select w2.id from weather w1 join weather w2 on datediff(day,w2.recorddate,w1.recorddate)=1
where w1.temperature<w2.temperature;                                        
                                          
#262. Trips Cancellation Rate for unbanned users
select t.request_at as 'Day', cast(avg(case when status='completed' then 0 else 1.0 end) as decimal(3,2)) as 'Cancellation Rate'
from trips as t inner join users c on t.client_id=c.user_id inner join users d on t.driver_id=d.user_id
where c.banned='no' and d.banned='no' and t.request_at between '2013-10-01' and '2013-10-03'
group by t.request_at;
                                                                                                
#512. The earlist Game Play                                          
select a.playrt_id, device_id from activity a 
join (select player_id, min(event_date min_date from activity group by player_id) tmp
on a.player_id=tmp.player_id and a.event_date=tmp.min_date;
##############################
select player_id, device_id from avtivity where concat(player_id, event_date) in 
 	 	(select concat(player_id, min(event_date) from activity group by player_id );
##############################
select player_id, device_id from (select player_id, device_id, dense_rank() over(partition by player_id order by event_date) as r 
                                  from activity) tb1
where r=1;                                      
                                          
#550. Users who played in the second day.                                          
select cast(count(distinct a2.player_id)*1.0/count(distinct a1.player_id) as decimal(3,2))  as fraction                                        
from (select player_id, min(event_date) as event_date from activtity froup by player_id) a1
left join activity a2 on a1.player_id=a2.player)id and datediff(day,a2.event_date,a1.event_date)=1;                                          
                                          
#570. Managers who manage more than 5 employees
select e2.name from employee e1 join employee e2 on e1.manager_id=e2.id group by e2.id, e2.name having count(e1.id)>=5;                                          
                                          
#574. Winning Candidate
select c.name from candidate c join vote v on v.candidateid=c.id
group by c.id,c.name
order by count(*) desc limit 1;            
                                          
#577. Employee Bonus
select e.name,b.bonus
from employee e left join bonus b 
on e.empid=b.empid where b.bonus is null or b.bonus<1000;
                                          
#580. Num of Students in departments                                          
select d.dept_name, count(student_id) As student_num
from department d left join student s on d.dept_id=s.dept_id
group by d.dept_id
order by count(student_id) desc, d.dept_name;            
                                          
#607. Sales Person
select name from salesperson 
where sales_id not in 
   (select o.sales_id from order o join company c on o.com_id=c.com_id where c.name='Red');
            
#614. Second degree follower
select f1.follower, count(distinct f2.follower) as num
from follow f1 join follow f2 on f1.follower=f2.followee
group by f1.follower
order by f1.follower;
###############################
select followee as follower, count(distinct follower) as num
from follow 
group by followee
having followee in (select follower from follow)
order by followee;

                                          
#615. Average salary department vs company
with tb1 as
(select distinct department_id, left(pay_date,7) as pay_month, 
       avg(amount) over(partition by department_id, left(pay_date,7)) as avg_dept,
       avg(amount) over(partition by left(pay_date,7))     as avg_comp
 from salary s join employee e on s.employee_id=e.employee_id)
select pay_month, department_id, case when avg_dept>avg_comp then 'Higher' 
                                      when avg_dept<avg_comp then 'Lower' 
                                      else 'Same' end as comparison
from tb1;
###################################
With dept as
(select e.department_id, left(s.salary,7) as pay_month, avg(s.amount) as avg_dept
 from salary s join employee e on s.employee_id=e.employee_id 
 group by e.department_id, left(s.salary,7)),
comp as
(select left(s.salary,7) as pay_month, avg(s.amount) as avg_comp
 from salary 
 group by left(s.salary,7))                     
select d.pay_month, d.department_id, case when d.avg_dept>c.avg_comp then 'Higher' 
                                      when d.avg_dept<c.avg_comp then 'Lower' 
                                      else 'Same' end as comparison
from dept d join comp c on d.pay_month = c.pay_month;

#1068. Product Sales Analysis
SELECT p.product_name, s.year, s.price
FROM Sales s
JOIN Product p
on s.product_id = p.product_id;
               
#1070. Product Sales Analysis
with tb1 as 
(select product_id, min(year) as first_year
 from sales group by product_id)
select s.product_id, first_year, quantity, price
from sales s join tb1 on s.prodcut_id=tb1.product_id and s.year=tb1.fisrst_year;
########################################
select product_id, year as first_year, quantity,price
from (select *, dense_rank() over (partition by product_id order by year) as r frm sales) tb1
where r=1;
########################################
select product_id, year as first_year, quantity, price
from sales s 
where year= (select year from sales where product_id=s.product_id order by year limit 1);

#1075. Project employee
select p.project_id, cast( avg(e.experience_year*1.0) as decimal (10,2)) as avg_years
from project p left join employee e on p.employee_id=e.employee_id
group by p.project_id;               
               
#1077. Project employee
With tb1 as
(select p.project_id, p.employee_id, e.experience_years
 from project p join employee e on p.employee_id=e.employee_id),
tb2 as
(select project_id, max(experience_years) as max_years
 from tb1 group by project_id)               
select project_id, employee_id from tb1 where experience_years= (select max_years from tb2 where project_id=tb1.project_id);
######################################
select project_id, employee_id 
from 
   (select p.project_id, p.employee_id, rank() over(partition by project_id order by experience_years  desc) as r
    from project p join employee e on p.employee_id=e.employee_id) tb1
where r=1;
                                                                  
#1083. Sales Analysis
With tb1 as
(select s.buy_id, p.product_name from sales s join product p on s.product_id=p.product_id)
select buyer_id from tb1 where product_name='S8' and buyer_id not in (select buyer_id from tb1 where product_name='iPhone');
			  

#1112. Highest Grade for each student
with tb1 as 
(select student_id , max(grade) as grade    
 from enrollments group by student_id)
select e.student_id, min(course_id), e.grade from enrollments e join tb1 
on e.student_id=tb1.student_id and e.grade=tb1.grade
group by e.student_id, e.grade
order by e.student_id;                                                               
##############################
with tb1 as 
(select *, row_number() over (partition by student_id order by grade desc, course_id) as r from enrollments)
select student_id, course_id, grade
from tb1 where r=1 order by student_id;



#1132. Reported Posts
with tb1 as  
(select a.action_date, count(distinct r.post_id)*100.0/count(distinct a.post_id) as daily_p
 from actions left join removals r on a.post_id=r.post_id
 where a.action='report' and a.extra='spam'
 group by a.action_date)                        
select cast(avg(daily_p) as decimal(5.2)) as average_daily_percent
from tb1;                        
                        
#1158. Market Analysis
select u.user_id as buyer_id, u.join_date as join_date,
       sum(case when year(order_date)=2019 then 1 else 0 end) as orders_2019
from users u left join orders o on u.user_id=o.user_id 
group by u.user_id, u.join_date;                        
############################                                          
with tb1 as
(select buyer_id, cout(*) as num from orders where year(order_date)=2019 group by buyer_id )                                          
select u.user_id as buyer_id, u.join_date , isnull(num,0) as orders_2019
from users u left join tb1 o on u.user_id=o.user_id;                                          
                                          
#1164. Product Price at a given date
with tb1 as
(select product_id, new_price from 
                                 (select product_id, new_price, row_number() over(partition by product_id order by change_date desc) as r
                                  from products where change_date<='2019-08-16') rank
  where r=1)                                   
select p.product_id, isnull(new_price,10) as price
from (select distinct product_id from products) p left join tb1 on p.product_id=tb1.product_id;
################################                                          
with tb1 as
(select product_id, max(change_date) as date from products where change_date<='2019-08-16' group by product_id),
tb2 as
(select p.product_id, p.new_price from products p join tb1 on p.prodcut_id=tb1.product_id and p.change_date=tb1.date)                                          
select p.product_id , isnull(new_price,10) as price 
from (select distinct product_id from products) p left join tb2 on p.product_id=tb2.product_id;                                         
                                          
#1204. Last person to fit the elevator
select q1.person_name
from queue q1 join queue q2 on q1.turn>=q2.turn 
group by q1.person_id, q1.person_name
having sum(q2.weight)<=1000
order by sum(q2.weight) desc limit 1;                                          
################################
select person_naem from (select person_name, turn, sum(weight) over (order by turn) as tw from Queue) tb1
where tw<=1000 order by turn desc limit 1;
				    
#1205. Monthly Transactions
with tb1 as
(select left(trans_date,7) as month , country, count(status) as approved_count, sum(amount) as approved_amount 
 from transactions where status='approved'
 group by left(trans_date,7), country)  ,
tb2 as
(select left(c.trans_date,7) as month, country, count(c.trans_id) as chargeback_count, sum(t.amount) as chargeback_amount
 from chargebacks c join transactions t on c.trans_id=t.id 
 group by left(trans_date,7), country)
select tb1.month as month,
       tb1.country as country,
       isnull(tb1.approved_count,0) AS approved_count,
       isnull(tb1.approved_amount,0) AS approved_amount,
       isnull(tb2.chargeback_count,0) AS chargeback_count,
       isnull(tb2.chargeback_amount,0) AS chargeback_amount
from tb1 left join tb2 on tb1.month=tb2.month and tb1.country=tb2.country
union all 
select tb2.month as month,
       ctb2.country as country,
       isnull(tb1.approved_count,0) AS approved_count,
       isnull(tb1.approved_amount,0) AS approved_amount,
       isnull(tb2.chargeback_count,0) AS chargeback_count,
       isnull(tb2.chargeback_amount,0) AS chargeback_amount
from tb1 right join tb2 on tb1.month=tb2.month and tb1.country=tb2.country
where tb1.month is Null;   

#1241. Number of comments per post
select s1.sub_id as post_id, count(distinct s2.sub_id) as number_of_comments
from submission s1
left join submission s2
on s1.sub_id=s2.parent_id
where s1.parent_id is null
group by s1.sub_id;                                     
                                    
#1270. All people report to the given manager
With RECURSIVE tmp as
(select employee_id from employees where manager_id=1 and employee_id=manager_id
 union
 select e.employee_id from employees e join tmp on tmp.employee_id=e.manager_id)
select employee_id
FROM tmp
OPTION (MAXRECURSION 3);                                          

#1280. Students and Examinations
select s.student_id, s.student_name, b.subject_name, count(e.student_id) as attended_exams
from students s cross join subjects b left join examinations e on s.student_id=e.student_id and b.subject_name=e.subject_name
group by  s.student_id, s.student_name, b.subject_name
order by s.student_id, b.subject_name;                                

#1294. Weather type in each country
select c.country_name, w.weather_type
from (select country_id, case when avg(weather_state*1.0)<=15 then 'Cold'
                              when avg(weather_state*1.0)>=25  then 'Hot'
                              else 'Warm' end as weather_type 
      from weather where left(day,7)='2019-11' group by country_id ) w
join countries on c.country_id=w.country_id;

#1303. Find the team size
select e1.employee_id, count(*) as team_size
from employee e1 join employee e2 on e1.team_id=e2.team_id
group by e1.employee_id;

#1327. List the Products ordered in a period
select min(p.product_name) as product_name, sum(unit) as unit
from orders o join products p on o.product_id=p.product_id
where year(o.order_date)=2020 and month(o.order_date)=2
group by p.product_id
having sum(unit)>=100;
                                    
#1336. Number of Transactions per visit
with tb1 as 
(select v.user_id, v.visit_date, count(t.transactin_date) as c
 from visits v left join transactions t on v.visit_date=t.transaction_date and v.user_id=t.user_id
 group by v.user_id, v.visit_date) ,
RECURSIVE cte as 
(select max(c) as c from tb1
 union all
 select c-1 from cte
 where c>0)                                   
select cte.c as transaction_count, count(tb1.user_id) AS visits_count
from cte left join tb1 
on cte.c=tb1.c
group by cte.c
order by cte.c;
                                    
#1350. Student with Invalid department
select s.id, s.name
from student.s left join department d on s.department_id=d.id
where d.id is Null;

#1364. Number of Trusted Contacts of a customer
With tb1 as
(select c.customer_id, c.customer_name, count(con.contact_name) as contacts_cnt, count(c2.customer_id) as trusted_contacts_cnt)
 from customers c left join contacts con on c.customer_id=con.user_id
                  left join customers c2 on con.contact_email=c2.email
 group by c.customer_id, c.customer_name)
select i.invoice_id, tb1.customer_name,i.price, tb1.contacts_cnt, tb1.trusted_contacts_cnt
from invoices i join tb1 
on i.user_id=tb1.customer_id
order by i.invoice_id;
                                          
#1378. Replace employee id with the unique identifier
select u.unique_id, e.name
from employee e left join employeeUNI u
on e.id=u.id;

#1384. Total Sales Amount by Year
With RECURSIVE cte as
(select min(period_start) as date, max(period_end) as end_date
 from sales
 union all
 select date_add(date, interval 1 day), end_date
 from cte
 where date< end_date --limit 100--)                                          
select s.product_id as product_id, p.product_name as product_name,
       cast(year(cte.date) as char(4)) as report_year,
        sum(average_daily_sales) as  total_amount
from cte join sales s on cte.date between s.period_start and s.period_end
         join products p on s,product_id=p.producct_id
group by s.product_id, p.product_name, Year(cte.date)
order by  product_id, report_year


Advanced Join
#################################################################                                     
#180. Consecutive Number
select distinct l1.num as consecutiveNums
from logs l1
join logs l2 on l1.id=l2.id-1 and l1.num=l2.num
join logs l3 on l1.id=l3.id-2 and l1.num=l3.num;


#534. Game Play Analysis 3
select a1.player_id, a1.event_date, sum(a2.games_played) as games_played_sofar
from activity a1 join activity a2 on a1.player_id=a2.player_id and a1.event_date>=a2.event_date
group by a1.player_id, a1.event_date;
                                   
#569. Median Employee Salary
with tb1 as 
(select e1.id, e1.employee,e1.salary, count(*) as r, (select count(*) from employee where company=e1.company) as num)
from employee e1, join employee e2 on e1.company=e2.company and (e1.salary >e2.salary or (e1.salary = e2.salary AND e1.id >= e2.id))
order by e1.id, e1.employee,e1.salary)
select id, company, salary
from tb1 where r between num*1.0/2 and num*1.0/2+1;

#579. Cumulative Salary
select e1.id, e1.month , sum (e2.salary) as salary
from employee e1 join employee e2 on e1.id=e2.id and e1.month>=e2.month and e1.month<=e2.month +2
where e1.month != (select max(month) from employee where id=e1.id)
group by e1.id, e1.month
order by e1.id, e1.month desc;
##########################################
select e.id, month, sum(salary) over(partition by id order by month rows between 2 preceding  and current row) as salary
from employee e where month!= (select max(month) from employee where id=e.id)
order by id, month desc;


#601. Traffic of Stadium
WITH tb1 AS 
( select s1.id as id1, s2.id as id2, s3.id as id3 from stadium s1, stadium s2, stadium s3
    WHERE s1.id + 1 = s2.id and s2.id + 1 = s3.id and s1.people >= 100 and s2.people >= 100 and s3.people >= 100)
select * from stadium
where id in (select id1 id from tb1
             union 
             select id2 from tb1
             union 
             select id3 from tb1);
                                   
#603. Consecutive Availiable Seats
select c2.seat_id
from cinema c1 right join cinema c2 on c1.seat_id+1=c2.seat_id
left join cinema c3 on c2.seat_id+1=c3.seat_id 
where c2.free=1 and (c1.free = 1 OR c3.free = 1);
###################################
with tb1 as
(select seat_id, row_number() over(order by seat_id) as r from cinema where free=1).
tb2 as 
(select seat_id,count(*) over(partition by (seat_id-r)) as num from tb1)
select seat_id from tb2 where num>=2;
##################################
with tb1 as 
(select seat_id, free as free1, lead(free,1) over (order by seat_id) as free2, 
  lag(free,1) over (order by seat_id) as free0 from cinema)
select seat_id from tb1 where free1=1 and (free2=1 or free0=1);



#612. Shortest Distance
select cast(min(squt(power(p1.x-p2.x,2)+power(p1.y-p2.y,2))) as decimal(10,2)) as shortest
from point_2d p1
join point_2d p2 on p1.x!=p2.x or p1.y!=p2.y; ---OR here very important---

#613. Shortest Distance
select min (abs(p1.x-p2.x))as shortest
from point p1
join point p2 on p1.x!=p2.x;
#########################
select min(next-x) AS shortest
from (
    select x, lead(x) OVER (order by x) AS next
    from point
) tb1;		

#1097. Game play analysis
select a1.event_date as install_dt, count(distinct a1.player_id) as installs, 
       cast( count(desitinct a2.player_id)*1.0/count(distinct a1.player_id) as decimal(3,2)) as day1_retention
from (select player_id, min(event_date) as event_date from activity group by player_id) a1
      left joion activity a2 on a1.player_id=a2.player_id and datediff(a2.event_date,a1.event_date)=1
group by a1.event_date;

#1126. Acive Businesses
with tb1 as
(select *, avg(occurences*1.0) over (partition by event_type) as avg_oc from events)
select business_id from tb1 group by business_id having sum(case when occurences>avg_oc then 1 else 0 end)>1;                                 
##########################################
with tb1 as
(select event_type , avg(occurences*1.0) as avg_oc from events group by event_type)
select business_id from event e join tb1 on e.event_type=tb1.event_tpye and e.occurences > tb1.avg_oc 
group by business_id 
having count(*)>1;                                       
                                    
#1127. User Purchase Platform
With tb1 as
(select user_id, spend_date,amount, case when count(*) over (partition by user_id, spend_date)=1 then platform else 'both' end as platform
 from spending),
tb2 as
(select spend_date, platform, sum(amount) as total_amount, count(distinct user_id) as total_users
 from tb1 group by spend_date, platform),
d as
(select distinct spend_date from tb2),
p as 
(select 'desktop' as platform union select 'mobile' union select 'both')
select d.spend_date, p.platform, isnull(total_amount,0) as total_amount, isnull(total_users,0) as total_users
from d join p
left join tb2 on d.spend_date=tb2.spend_date and p.platform=tb2.platform;                                    
                                    
#1159. Market Analysis
with tb1 as
(select seller_id, item_id from 
        (select seller_id, item_id, row_number() over (partition by seller_id order by order_date) as r from order) rank 
 where r=2)
select u.user_id as seller_id, case when u.favorite_brand=i.item_brand then 'yes' else 'no' end as '2nd_item_favbrand'
from users u left join tb1 on u.user_id=tb1.seller_id left join items i on i.item_id=tb1.item_id;
##############################################################
with tb1 as
(select o1.seller_id,o1.item_id from orders o1 join orders o2 on o1.seller_od=o2.seller_id and o1.order_date>=o2.order_date
 group by o1.seller_id,o1.order_date,o1.item_id
 having count(*)=2)
select u.user_id as seller_id, case when u.favorite_brand=i.item_brand then 'yes' else 'no' end as '2nd_item_favbrand' 
from users u left join tb1 on u.user_id=tb1.seller_id left join items i on i.item_id=tb1.item_id;

#1194. Tournament_winners
with tb1 as
(select first_player as player, first_score as score from matches union select second_player, second_score from matches),
tb2 as
(select p.player_id, p.group_id, sum(tb1.score) as tp
from players p left join tb1 on p.player_id=tb1.player
group by p.player_id, p.group_id)                                                                                       
select group_id,player_id from
         (select player_id, group_id , row_number() over(partition by group_id order by tp desc, player_id) as r from tb2) tb3
where  r=1;
####################################                                                                                       
with tb1 as 
(select player_id, group_id, sum(case when player_id=first_player then first_score else second_score end) as tp
from players p left join matches m on p.player_id=m.first_player or p.player_id=m.second_player
group by player_id, group_id)
select group_id,player_id from
         (select player_id, group_id , row_number() over(partition by group_id order by tp desc, player_id) as r from tb1) tb2
where  r=1;                                 
####################################                                        
with tb1 as 
(select player_id, group_id, sum(case when player_id=first_player then first_score else second_score end) as tp
from players p left join matches m on p.player_id=m.first_player or p.player_id=m.second_player
group by player_id, group_id)                                
select l.group_id, l.player_id
from tb1 l join tb1 r on l.group_id = r.group_id and (l.tp < r.tp or (l.tp = r.tp and l.player_id >= r.player_id))
group by l.group_id, l.player_id
having count(*) = 1;                                    
                                    
#1212. Team Score in football tournation
select team_id, team_name, sum( case when team_id=host_id and host_goals>guest_goals then 3
                                     when team_id=guset_id and guest_goals>host_goals then 3
                                     when host_goals=guest_goals then 1
                                     else 0 end ) as num_points
from teams t left join matches m on t.team_id=m.host_team or t.team_id=m.guest_team 
group by team_id, team_name 
order by num_points desc, team_id; 

#1225 Report Contiguous Date
with tb1 as
(select f1.fail_date as date, 'failed' as s, count(*) as r
 from failed f1 join failed f2 on f1.fail_date>=f2.fail_date
 group by f1.fail_date
 union 
 select s1.succeeded_date as date, 'succeeded' as s, count(*) as r
 from succeeded s1 join succeeded s2 on s1.success_date>=22.success_date
 group by s1.succeeded_date),
tb2 as 
(select *, year(date) as r2 from tb1 where year(date)=2019)
select s as period_state, min(date) as start_date, max(date) as end_date
from tb2
group by r2-r,s
order by start_date;
                                                                      
#1251. Average selling price
select u.product_id, case(sum(price*units)*1.0/sum(units) as decimal(10,2)) as average_price
from unitssold u join price p on u.product_id=p.product_id and u.purchase_date>=p.start_date and u.purchase_date<=p.end_date                                                                    
group by  u.product_id;                                                                     
                                                                      
#1285. Find the start and end number of continuous ranges
with tb1 as 
(select l1.log_id, count(*) as r 
  from logs l1 join logs l2 on l1.log_id>=l2.log_id
 group by  l1.log_id)  
select min(log_id) as start_id, max(log_id) as end_id
from tb1
group by log_id-r;                                                                    
###################################                                                                      
select min(log_id) as start_id, max(log_id) as end_id
from(
	select *, (@id:=@id+1) as id
	from logs, (select @id:= 0) as init
) tmp
group by log_id - id                                                                      
###################################
select l1.log_id as start_id, l2.log_id as end_id
from
  (
    select log_id
    from Logs
    where log_id - 1 not in (select * from Logs)
  ) as l1,
  (
    select log_id
    from Logs
    where log_id + 1 not in (select * from Logs)
  ) as l2
where l1.log_id <= l2.log_id
group by l1.log_id;
                                
#1308. Runing total for different genders
select s1.gender,s1.day,sum(s2.score_points) as total
from scores s1
join scores s2
on s1.gender=s2.gender and s1.day>=s2.day
group by s1.gender,s1.day
order by s1.gender,s1.day;                                     
                                    
#1321. Restaurant Growth
with total as
(select visited_on, sum(amount) as amount
from customer
group by visited_on)
select t1.visited_on, sum(t2.amount) as amount, cast(avg(t2.amount*1.0) as decimal(10,2) as average_amount)
from total t1 join total t2 on t1.visited_on>=t2,visited_on and t1.visited_on<= date_add(t2.visited_on, interval 6 day)
group by t1.visited_on
having count(t2.visited_on)=7
order by t1.visited_on;                                    
                                    
#1369. Get the second most activity
with tb1 as
(select u1.username, u1.activity, u1.startdate , u1.enddate, count(*) as r
from useractivity u1 join useractivity u2 on u1.username = u2.username AND u1.endDate <= u2.endDate
group by 1.username, u1.activity, u1.startDate, u1.endDate) ,
tb2 as
(select username, count(*) as c from useractivity group by username)
select tb1,username, tb1.activity, tb1.startdate, tb1.enddate
from tb1 join tb2 on tb1.username=tb2.username 
where tb1.r=tb2.c or tb2.c=1;                                   


Subquery
######################################################################################################
#176. Second largest salary
select max(salary) as secondhighestsalary
from employy
where salary < (select max(salary) from employee);
								    
#571. Median given frequency of numbers
with tb1 as 
(select * ,sum(frequency) over (order by number) as cum_num, sum(frequency) over () as num from numbers)
select avg(number*1.0) as median from tb1 where num/2.0 between cum_num-frequency and cum_num;                                                                   
                                                                     
#602. Who has the most friends
with tb1 as 
(select requester_id as id from request_accepted union all select accepter_id from request_accepted) 
select id, count(*) as num from tb1 group by id order by count(*) desc limit 1;                                                                    
                                                                     
#608. Tree Node
select id, case when p_id is null then 'Root'
                when p_id is not null and id in (select distinct p_id from tree) then 'Inner'
                else 'Leaf' end as Type
from tree;
								     
#618. Students report by geography
with tb1 as
(select  row_number() over (partition by continent order by name) as r , 
           if(continent = 'America', name, NULL) AS America,
           if(continent = 'Asia', name, NULL) AS Asia,
           if(continent = 'Europe', name, NULL) AS Europe
 from student)
select MIN(America) AS America, MIN(Asia) AS Asia, MIN(Europe) AS Europe
from tb1
group by r;
##############################################								     
select  America, Asia, Europe
from
  (select row_number() over (partition by continent order by name) AS r, name AS Asia
   from student where continent = 'Asia') AS t1
  right join 
  (select row_number() over (partition by continent order by name) AS r, name AS America
   from student where continent = 'America') AS t2 ON t1.r = t2.r
  left join
  (select row_number() over (partition by continent order by name) AS r, name AS Europe
   from student where continent = 'Europe') AS t2 ON t2.r = t3.r;							     
#############################################
select America, Asia, Europe
from (select @as:=0, @am:=0, @eu:=0) t,
     (select @as:=@as + 1 AS asid, name AS Asia from student where continent = 'Asia' order by Asia) AS t1
    right join (select @am:=@am + 1 AS amid, name AS America from student where continent ='America'  order by America) AS t2 on t1.asid = t2.amid
    left join (select @eu:=@eu + 1 AS euid, name AS Europe from student where continent ='Europe'  order by Europe) AS t3 on t2.amid = t3.euid;

#626. Exchange Seats
select case when id%2=1 and id=(select max(id) from seat) then id
            when id%2=1 then id+1
            else id-1 end as id, student
from seat order by id;

#1045. Customers who bought all products
select customer_id from customer group by customer_id
haveing count(distinct product_key)= (select count(*) from product);
 
#1084. Sales Analysis 3
select product_id, product_name from product 
where product_id in (select product_id from sales where sale_date between '2019-01-01' and '2019-03-31' ) 
      and product_id not  in (select product_id from sales where not sale_date between '2019-01-01' and '2019-03-31' ); 								     
								     
#1098. Unpopular Books
select book_id, name from books where available_from <='2019-05-23'
 and bood_id not in (select book_id from orders where dispatch_date>='2018-06-24' group by book_id having sum(quantity)>=10);
####################################
decalre @d int;
set @d='2019-06-23';
select book_id, name from books where available_from <=date_sub(@d, interval 1 month)
 and bood_id not in (select book_id from orders where dispatch_date>=date_add(@d, interval 1 year) group by book_id having sum(quantity)>=10);

								     
#1107								     


								     
								     
								     
								     
