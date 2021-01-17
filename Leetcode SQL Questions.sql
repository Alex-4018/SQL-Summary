#182. Duplicate Emails
select email from person group by email having count(*)>1;

#511. Game Play Analysis
select player_id, min(event_date) as first_login
from activity group by player_id;

#578. Highest answer rate
-- Note: answer rate = answer actions / total non-answer actions
select question_id from suervey_log
group by survey_od 
order by count(answer_id)/(count(*)-count(answer_id)) desc
limit 1;
                                           
#584. Find Customer Referee
                                          








































