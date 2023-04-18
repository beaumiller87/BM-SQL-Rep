select
  d.deal_id AS "Deal ID"
  ,  'www.redfin.com/tools/deals/' || d.deal_id AS "Deal Page URL"
  ,  d.property_address_street AS "Property Address"
  ,  CONCAT(p.first_name,' ',p.last_name) AS "Customer Name"
	,  CONCAT(ap.first_name,' ',ap.last_name) AS "Agent Name"
	,  bm.name AS "Market"
	,  d.mls_id AS "MLS# Received"
	,  TO_CHAR(li.last_updated_date, 'MM/DD/YYYY') AS "Last MLS Update"
	,  TO_CHAR(li.sale_date, 'MM/DD/YYYY') AS "MLS Sold Date"
	,  TO_CHAR(d.close_date, 'MM/DD/YYYY') AS "Deal Page Close Date"
	,  d.close_price AS "Final Price"
	,  li.sale_price AS "MLS Sold Price"
	,  CASE
		WHEN li.search_status_id = 1 THEN 'ACTIVE'
		WHEN li.search_status_id = 2 THEN 'CONTINGENT'
		WHEN li.search_status_id = 4 THEN 'SOLD'
		WHEN li.search_status_id = 8 THEN 'PRE_ON_MARKET'
		WHEN li.search_status_id = 16 THEN 'OFF_MARKET'
		WHEN li.search_status_id = 64 THEN 'UNKNOWN'
		WHEN li.search_status_id = 32 THEN 'NULL'
		WHEN li.search_status_id = 128 THEN 'PENDING'
	END AS "MLS Status"
  ,  CASE
    WHEN d.deal_status_id = 7 THEN 'Listing - Active'
		WHEN d.deal_status_id = 13 THEN 'Offer - Pending'
		WHEN d.deal_status_id = 26 THEN 'Offer - Short Sale'
		WHEN d.deal_status_id = 27 THEN 'Offer - Mutual Acceptance'
		WHEN d.deal_status_id = 53 THEN 'Listing - Mutual Acceptance'
	END AS "Deal Page Status"
	,  'www.redfin.com/xx/home/' || li.property_id AS "Redfin LDP"
from deals d
	JOIN logins l ON d.login_id = l.login_id
	JOIN persons p ON l.person_id = p.participant_id
	JOIN agents a ON a.agent_id = d.agent_id
	JOIN persons ap ON ap.participant_id = a.person_id
	JOIN business_markets AS bm ON bm.business_market_id = a.business_market_id
	LEFT JOIN listings li ON d.listing_id = li.listing_id

where d.deal_classification_id = 2
	AND d.is_redfin_deal = 't'
	AND d.deal_status_id IN (7,13,26,27,53)
	AND d.close_date < CURRENT_DATE
	OR (d.deal_status_id = 7 
	 AND li.search_status_id IN (4, 16, 64, 32) 
	 AND d.deal_classification_id = 2 
	 AND d.is_redfin_deal = 't')
ORDER BY li.search_status_id, d.close_date

	
