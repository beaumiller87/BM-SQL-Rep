SELECT CONCAT(p.first_name,' ',p.last_name,' (',bm.name,')') as "Name",
       TRIM(LEADING '+1' FROM ph.phone_number) as "Mobile Phone",
       a.agent_id,
       p.participant_id,
       a.phone_in_contact_box       
FROM agents AS a
  LEFT JOIN persons AS p ON a.person_id = p.participant_id
  LEFT JOIN business_markets AS bm ON bm.business_market_id = a.business_market_id
  LEFT JOIN (SELECT ph.participant_id,
                    ph.phone_number
             FROM phones AS ph
             WHERE ph.phone_type_id = 3
             AND ph.access_level = 3) ph ON ph.participant_id = p.participant_id
WHERE a.agent_type = 2
AND   a.is_active = 't'


