#1.  Patter
select repeat('*',1) union all
select repeat('*',2) union all
select repeat('*',3) union all
select repeat('*',4) union all
select repeat('*',5) union all
######################################
set @row := 0;
select repeat('* ', @row := @row + 1) from information_schema.tables 
where @row < 20;


#2. Reversed Patter
select repeat('*',5) union all
select repeat('*',4) union all
select repeat('*',3) union all
select repeat('*',2) union all
select repeat('*',1) union all
######################################
set @number =6;
select repeat('*',@number:=@number-1) from information_schema.tables
where @number>1;

#3. Prime numbers until 1000
set @num=1;
create table number as
select @num:=@num+1 as NUM from
   information_schema.tables,
   information_schema.tables t2
   where @num<=999;
   
create table number2 as
select a.num
from number a, number b
where a.num%b.num=0 and a.num>b.num and b.num>1;

select group_concat(a.num separator '&')
from number a 
where a.num not in (
                    select * from number2);
                    
#4.15 Days contest
select t5.submission_date, t5.total, h.hacker_id, h.name
from (
      select submission_date, count(distinct hacker_id) total
      from submissions s 
      where s.submission_date='2016-03-01' or (datediff('days',s.submission_date,'2016-03-01')= (
                                                        select count(distinct submission_date, hacker_id) from submission t2 
                                                        where s2.submission_date< s.submission_date and s2.hacker_id=s.hacker_id)
      group by submission_date) t5
inner join ( select t1.submission_date, min(t1.hacker_id) hacker_id 
              from (
                     select submission_date, hacker_id, count(hacker_id) total
                     from submissions
                     group by submission_date, hacker_id) t1,
                   (
                     select submission_date, max(total) max_total
                     from
                           ( select submission, hacker_id, count(hacker_id) total
                             from submissions
                             group by submission_date,hacker_id) t2
                     group by submission_date) t3
                     where t1.submission_date=t3.submission_date and t1.total=t3.max_total
                     group by t1.submission_date
               ) t4  
on t4.submission_date=t5.submission_date
left join hackers h on h.hacker_id=t4.hacker_id;             
###########################################                                                                                  
With R(submission_date,hacker_id) As
   (select distinct submission_date, hacker_id from submissions where submission_date=to_date('2016-03-01')
    union all 
   (select child.submission_date, child.hacker_id from R parent, submissions child
    where parent.submission_date+1=child.submission_date and parent.hacker_id=child.hacker_id),
Total As 
   (select submission_date,count(distinct hacker_id) as total from R group by submission_date),
Counter As
   (select submission_date, hacker_id, count(hacker_id) as N from submissions group by submission_date,hacker_id),
Maxperday As
   (select submission_date, min(c.hacker_id) from counter c
    where c.n= (select max(K.N) from counter K where c.submission_date=k.submission_date)
    group by submission_date,hacker_id)

Select total.submission_date,total.total,hackers.hacker_id,hackers.name from total
join maxperday on total.submission_date=maxperday.submission_date
join hackers on hackers.hacker_id=maxperday.hacker_id
order by total.submission_date;
    
#5. Project combination
select p1.start.date, p2.end_date
from projects p1 join projects p2 on datediff(p2.end_date,p1.start_date)=
            (select count(*) from projects where start_date>=p1.start_date and end_date<=p2.end_date)
            and p1.start_date-1 not in (select start_date from projects)
            and p2.end_date+1 not in (select end_date from projects)
order by datediff(p2.end_date,p1.start_date), p1.start_date;
###########################################                                                       
select start_date, min(end_date)
from (select start_date from projects where start_date not in (select end_date from projects)) a,
     (select end_date from projects where end_date not in (select start_date from projects)) b
where start_date<end_date
group by start_date
order by datediff(end_date,start_date), start_date;
###########################################                                                       
select start_date, min(end_date)
from (select start_date from projects A left join projects B on a.start_date=b.end_date where b.task_id is null) As start
join
     (select end_date from projects A left join projects B on a.end_date=b.start_date where b.task_id is null) As end
on start_date<end_date
group by start_date
order by datediff(end_date,start_date), start_date;

#6. Advanced Merge

Create View total_views As
(select challenge_id, sum(total_views) as a, sum(total_unique_views) as b from view_stats group by challenge_id);
Create View Sub As
(select challenge_id, sum(total_submissions) as c, sum(total_accepted_submissions) as d from Submission_Stats group by challenge_id);
##################################
#'With' Statement is Available in MySQL 8.0 
With total_views As
(select challenge_id, sum(total_views) as a, sum(total_unique_views) as b from view_stats group by challenge_id),
 Sub As
(select challenge_id, sum(total_submissions) as c, sum(total_accepted_submissions) as d from Submission_Stats group by challenge_id)
select contests.contest_id, contests.hacker_id,contests.name, sum(a), sum(b),sum(c),sum(d) from contests 
       left join 
       colleges on contests.contest_id=colleges.contest_id
       left join 
       challenges on colleges.colleges_id=colleges.colleges_id
       left join 
       total_views on total_views.challenge_id=challenges.challenge_id
       left join 
       sub on sub.challenge_id=challenges.challenge_id
group by contests.contest_id, contests.hacker_id,contests.name 
having  sum(a)!=0  or sum(b)!=0 or sum(c)!=0 or sum(d)!=0
order by contests.contest_id;
     
     
     
#7. create coding challenges
select c.hacker_id, h.name, count(c.hacker_id) as total 
from challenges c
inner join hackers h 
on h.hacker_id=c.hacker_id
group by c.hacker_id,h.name
having total= (select max(temp1.cnt) from (select count(hacker_id) as cnt from challenges group by hacker_id) temp1
    or total in (select temp2.cnt from (select count(hacker_id) as cnt from challenges group by hacker_id) temp2 group by temp2.cnt having count(temp2.cnt)=1)
order by total desc,c.hacker_id;
##################################
select c.hacker_id, h.name, count(c.hacker_id) as total 
from challenges c
inner join hackers h 
on h.hacker_id=c.hacker_id
where c.hacker_id not in (select t1.hacker_id from 
                                            (select hacker_id, count(*) cnt from challenges group by hacker_id) as t1 
                                            inner join 
                                            (select hacker_id, count(*) cnt from challenges group by hacker_id) as t2
                                            on t1.challenge_id!=t2.challenge_id and t1.cnt=t2.cnt and t1.cnt!= (select max(cnt) from t1))
group by c.hacker_id
order by total desc,c.hacker_id;


#8. Median
select round(avg(a.LAT_N),4) from station a
where abs((select count(lat_n) from station where a.lat_n>lat_n)-(select count(lat_n) from station where a.lat_n<lat_n))<=1;
##################################
set @rowid=0;
select round(avg(t.lat_n),4) from (select @rowid :=@rowid+1 as rowid, lat_n from station order by lat_n) as t
where t.rowid in  (ceil((@rowid+1)/2), floor((@rowid+1)/2));
##################################
select round(avg(a.lat_n),4) from station a, station b 
group by a.lat_n 
having sum(sign(1-sign(b.lat_n-a.lat_n)))=ceil((count(*)+1)/2);
##################################
select round(avg(a.lat_n),4) from station a, station b 
group by a.lat_n 
having sum(sign(b.lat_n-a.lat_n))=0;

#9. Triangles
Select case when A+B>C or B+C>A or A+C>B then 
             case when A=B and B=C then 'Equilateral'
                  when (A=B and A!=C) or  (A=C and A!=B) or (B=C and A!=B) then  'Isosceles'
                  when A!=B and A!=C and B!=C then 'Scalene'
       else 'Not a Triangle'
       end
from Triangles;
##################################
Select case when A+B<=C or B+C<=A or A+C<=B then 'Not a Triangle'
            when A=B and B=C then 'Equilateral'
            when A=B or  A=C  or B=C  then  'Isosceles'
            else 'Scalene'
       end
from Triangles;


#10. Pivot Table
select max(a.doctor), max(a.professor), max(a.singer),max(a.actor)
from (select case when occupant='Doctor' then name end as doctor,
             case when occupant='Professor' then name end as professor,
             case when occupant='Singer' then name end as singer,
             case when occupant='Actor' then name end as actor,
             row_number() over(partition by occupation order by name) as rank
        from occupations) as a
group by a.rank;
##################################
set @drowno=0;
set @prowno=0;
set @srowno=0;
set @arowno=0;
select  max(doctor), max(professor), max(singer),max(actor) from 
(select a.p as p,
case when occupation='Doctor' then name else NULL end as Doctor,
case when occupation='Professor' then name else NULL end as Professor,
case when occupation='Singer' then name else NULL end as Singer,
case when occupation='Actor' then name else NULL end as Actor
from
(select * from (select Name, Occupation, @drowno:=@drowno+1 as p from Occupations where occupation='Doctor' order by name asc) as do
union
select * from (select Name, Occupation, @prowno:=@prowno+1 as p from Occupations where occupation='Professor' order by name asc) as pr
union
select * from (select Name, Occupation, @srowno:=@srowno+1 as p from Occupations where occupation='Singer' order by name asc) as si
union
select * from (select Name, Occupation, @arowno:=@arowno+1 as p from Occupations where occupation='Actor' order by name asc) as ac) as a ) b
group by b.p;
##################################
set @allrowno=0;
set @drowno=0;
set @prowno=0;
set @srowno=0;
set @arowno=0;
select  d.name,p.name,s.name,a.name  
from
(select Name, @allrowno:=@allrowno+1 as p from Occupations order by name asc) as al
left join
(select Name, @drowno:=@drowno+1 as p from Occupations where occupation='Doctor' order by name asc) as d
on al.p=d.p
left join
(select Name, @prowno:=@prowno+1 as p from Occupations where occupation='Professor' order by name asc) as p
on al.p=p.p
left join
(select Name, @srowno:=@srowno+1 as p from Occupations where occupation='Singer' order by name asc) as s
on al.p=s.p
left join
(select Name, @arowno:=@arowno+1 as p from Occupations where occupation='Actor' order by name asc) as a
on al.p=a.p
where d.name is not NULL or p.name is not NULL or s.name is not NULL or a.name is not NULL;

#11. Tree
select N, case when p is null then 'Root'
               when  n in (select p from BTS) then 'Inner'
               else 'Leaf'
               end;
from BTS
order by N;


#12. Regular Expression
select distinct city from station where city REGEXP/RLIKE  '^[AEIOU]' order by city;(No case Sensitive)
select distinct city from station where city REGEXP/RLIKE binary '^[AEIOU]' order by city; (Upper case)
select distinct city from station where city REGEXP/RLIKE  '[AEIOU]$' order by city;
select distinct city from station where city REGEXP/RLIKE  '^[AEIOU].*[AEIOU]$' order by city;
select distinct city from station where city REGEXP/RLIKE  '^[^AEIOU]' order by city;
select distinct city from station where city NOT REGEXP/RLIKE  '^[AEIOU]' order by city;
select distinct city from station where city REGEXP/RLIKE  '^[^AEIOU].*[^AEIOU]$' order by city;
select distinct city from station where city NOT REGEXP/RLIKE  '^[AEIOU]' and city NOT EXPREG/RLIKE '[AEIOU]$' order by city;


#13. Moving Average 
select a.order_date,a.sale. round( select sum(b.sale)/ count(b.sale) from sales as b where datediff(a.order_date,b.order_date) between 0 and 4) ,2) as '5daymoving average'
from sales as a
order by a.order_date
                                                
#14. Cumulative Totals
select t.day, t.rental_count, @running_total:=@running_total+t.rental_total as cumulative_sum
from
(select date(rental_date) as day, count(rental_id) as rental_count from rental group by day) t
join (select @running_total:=0) r 
order by t.day;
##########Or set @running_total=0; at the begining######




