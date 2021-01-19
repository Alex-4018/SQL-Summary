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
                                     
                                          
SQL Command
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
                                          
#184. Employee in each Department with highest salary
With max_salary as
(select department_id, max(salary) as max_salary from employee group by department_id)                                          
select d.name department, e.name employee, e.salary 
from max_salary ms join employee e on ms.department_id=e.department_id and ms.salary=e.salary
join department d on e.department_id=d.id;   
                                          
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
(select s.buy_id, p.product_name from sales join product p on s.product_id=p.product_id)
select buyer_id from tb1 where product_name='S8' and buyer_id not in (select buyer_id from tb1 where product_name='iPhone');
                                                
#1112. Highest Grade for each student
with tb1 as 
(select student_id , max(grade) as grade    
 from enrollments group by student_id)
select e.student_id, min(course_id), e.grade from enrollments e join tb1 
on e.student_id=tb1.student_id and e.grade=tb1.grade
group by e.student_id, e.grade
order by e.student_id, e.grade;                                                               

#1132. Reported Posts
with tb1 as  
(select a.action_date, count(distinct r.post_id)*100.0/count(distinct a.post_id) as daily_p
 from actions left join removals r on a.post_id=r.post_id
 where a.action='report' and a.extra='spam'
 group by a.action_date)                        
select cast(avg(daily_p) as decimal(5.2)) as average_daily_percent
from tb1;                        
                        
                        
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          

                                         



                                          
                                          
