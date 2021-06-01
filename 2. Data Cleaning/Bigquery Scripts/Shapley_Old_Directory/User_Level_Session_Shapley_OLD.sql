#Objective: This script is for "User Level Session" based on grouping done in parallel to cleaning.
#Input Table:festive-radar-307222.mta_data.mta_data_grouping_shapley2 => Cleaned table and grouped visitor source data.
#Conclusion: Based on PG Recommendation, grouping of visitor sources will be done after data cleaning and after creating all conversion paths for the users.

CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_session_shapley2 AS 
(
  SELECT
    d1.*,
    session_id
  FROM 
    `festive-radar-307222.mta_data.mta_data_grouping_shapley2` d1
  LEFT JOIN 
    (SELECT
      user_analytics_id,
      created_at,
      referred_to_url,
      SUM(IF(FLOOR(MIN(time_diff_sec)/60) < 30 OR MIN(time_diff_sec) IS NULL, 0, 1)) OVER (PARTITION BY user_analytics_id, Date ORDER BY created_at) session_id
    FROM `festive-radar-307222.mta_data.mta_data_grouping_shapley2`
    GROUP BY user_analytics_id, created_at, Date, referred_to_url
    ORDER BY user_analytics_id, created_at) d2 
  ON d1.user_analytics_id = d2.user_analytics_id AND d1.created_at = d2.created_at AND d1.referred_to_url = d2.referred_to_url
  ORDER BY 
    d1.user_analytics_id, visitor_source
)
;