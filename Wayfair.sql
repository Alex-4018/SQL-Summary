#1. Recipients whose sum of Last 3 transfers are more than 1024
SELECT recipient AS account_name 
FROM
     (SELECT recipient,SUM(amount) AS s
      FROM
           (SELECT recipient,amount 
            FROM
                (SELECT *,row_number()OVER(PARTITION BY recipient ORDER BY amount DESC) AS rn FROM transfers) AS T
            WHERE rn<=3) AS T2
      GROUP BY recipient) T3
WHERE s>=1024;

#2. Find Happy Duck in the ponds
SELECT pond_id, SUM(happyORnot)AS happy_ducks 
FROM (SELECT *
          FROM 
            (SELECT ponds.id AS pond_id,ponds.temperature AS pond_temperature,ducks.id AS duck_id,species.temp_preferences,species.temp_limit 
            FROM ponds 
            INNER JOIN ducks ON ducks.pond_id=ponds.id INNER JOIN species ON species.id=ducks.species_id
            WHERE (ponds.temperature <= species.temp_limit and species.temp_preferences='+') OR
           (ponds.temperature >= species.temp_limit and species.temp_preferences='-')
           ) AS T1
      )AS T2
GROUP BY pond_id;

#3. Country Export and Import amount
SELECT T1.country,exported,imported 
FROM
   (SELECT country,IFNULL(SUM(outport),0) AS exported
    FROM 
         (SELECT companies.country,trade.seller,trade.value AS outport 
          FROM companies LEFT JOIN trade ON companies.name=trade.seller) AS T_out
          GROUP BY country) T1
          LEFT JOIN
         (SELECT country,IFNULL(SUM(inport),0) AS imported
          FROM 
              (SELECT companies.country,trade.buyer,trade.value AS inport 
               FROM companies LEFT JOIN trade ON companies.name=trade.buyer) AS T_in
               GROUP BY country) T2
         ON T1.country=T2.country;

#4. NUm of Passengers in the bus
SELECT bus_id,count(p_id) AS passengers_on_board FROM
  (SELECT bus_id,p_id FROM
       (SELECT *,row_number()OVER(PARTITION BY p_id ORDER BY b_time-P_time) AS rn
        FROM
            (SELECT buses.id AS bus_id,passengers.id AS p_id, buses.time AS b_time, passengers.time AS p_time
             FROM buses LEFT JOIN passengers
             ON buses.origin=passengers.origin AND buses.destination = passengers.destination AND buses.time>=passengers.time
             ORDER BY buses.time-passengers.time) T) T2
   WHERE rn=1)T3
GROUP BY bus_id
ORDER BY bus_id;


#5. Num of Tickets for each plays
SELECT id,title,SUM(number_of_tickets) AS reserved_tickets
FROM
   (SELECT plays.id,plays.title,reservations.number_of_tickets,reservations.theater 
    FROM plays LEFT JOIN reservations
    ON plays.id=reservations.play_id) AS T
GROUP BY id
ORDER BY id;

#6. Team Scores
SELECT team_id,team_name,SUM(host_score) AS num_points
FROM 
    (SELECT teams.team_id,teams.team_name,IF(host_goals>guest_goals,3,IF(host_goals=guest_goals,1,0)) AS host_score FROM teams 
     LEFT JOIN matches ON teams.team_id=matches.host_team
     UNION ALL
     SELECT teams.team_id,teams.team_name,IF(host_goals<guest_goals,3,IF(host_goals=guest_goals,1,0)) AS guest_score FROM teams 
     LEFT JOIN matches ON teams.team_id=matches.guest_team
     ORDER BY team_id) AS totalT
GROUP BY team_id,team_name
ORDER BY num_points DESC,team_id;
###########################
SELECT team_id, team_name,
    SUM(
        CASE WHEN team_id = host_team AND host_goals > guest_goals THEN 3
             WHEN team_id = guest_team AND guest_goals > host_goals THEN 3
             WHEN host_goals = guest_goals THEN 1
             ELSE 0
        END          
    ) AS num_points
FROM Teams t
LEFT JOIN Matches m 
ON t.team_id = m.host_team OR t.team_id = m.guest_team
GROUP BY team_id, team_name
ORDER BY num_points DESC, team_id;





