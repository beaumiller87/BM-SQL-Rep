Select
a.agent_id AS "Agent ID"
, CONCAT(ap.first_name,' ',ap.last_name) as "Agent Name"
, CONCAT('https://www.redfin.com/tools/agents/',a.agent_id) as "Agent URL"
, bm.name as "Market"
, case 
  when p.agent_brokerage_partnership_participation_id IS NULL then 'US Tiered Pricing'
  when p.agent_brokerage_partnership_participation_id IS NOT NULL then 'UPDATE - 25% Pricing'
  end as "Pricing Status"
from agents a
	join persons ap on ap.participant_id = a.person_id
	join business_markets bm on bm.business_market_id = a.business_market_id
	join agent_brokerage_partnership_participations as p on p.agent_id = a.agent_id
where bm.country_code != 'CA'
  and a.is_active
  and a.agent_type = 2
