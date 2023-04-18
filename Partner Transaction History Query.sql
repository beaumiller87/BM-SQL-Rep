SELECT d.deal_id as "Deal ID",
p.first_name||' '||p.last_name as "Agent Name",
(CASE WHEN d.deal_status_id=1 THEN 'Buy' ELSE 'List' END) as "Deal Type",
COALESCE(d.mls_id, 'N/A') as "MLS #",
to_char(d.close_date, 'MM/DD/YYYY') as "Close Date",
to_char(d.close_price, 'L999G999G999D99') as "Final Price",
d.property_address_street as "Property Street Address",
d.property_address_city as "Property City",
d.property_address_state_code as "Property State",
d.property_address_zip as "Property Zip",
to_char((d.redfin_revenue + d.partner_revenue), 'L999G999G999D99') as "Gross Commission",
to_char(d.redfin_revenue, 'L999G999G999D99') as "Referral Fee Due",
to_char(COALESCE(d.commission_check_amount_received,0.00), 'L999G999G990D00') as "Check Received Amount"
, (CASE WHEN d.commission_check_status_id = 2 THEN 'Check Expected'
		WHEN d.commission_check_status_id = 3 THEN 'Check Received'
		WHEN d.commission_check_status_id = 4 THEN 'Check Deposited'
		WHEN d.commission_check_status_id = 5 THEN 'Check Not Expected'
		WHEN d.commission_check_status_id = 6 THEN 'Sent to Collections'
		WHEN d.commission_check_status_id = 7 THEN 'Check Postponed'
	END) AS "Check Status"
from deals as d
	LEFT JOIN agents as a ON a.agent_id = d.agent_id
	LEFT JOIN persons AS p ON a.person_id = p.participant_id 
where d.deal_classification_ID = 2
and d.deal_status_id in(1,8)
and d.is_redfin_deal = 't'



