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












