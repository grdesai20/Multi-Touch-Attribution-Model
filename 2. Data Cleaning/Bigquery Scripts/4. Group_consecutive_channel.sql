#User level agg 1


'''
Since we already have aggregated the session ids for each customer session created which indicate us of a changed session. 

Here, we create identify the channels that appear consecutively. For example: For a user XYZ he might have visited through Email in Session 1 and also in Session 2. This script ill group the Channels (campagins) that appear consecutively in a user"s journey. The result of the script would be stored in a BigQuery table named mta_data_agg_1.



'''
CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_agg_1 AS 
(
  SELECT
    user_analytics_id, 
    session_cumsum,
    MAX(conv_1_life) conv_1_life,
    MIN(visitor_source) visitor_source
  FROM (SELECT
      user_analytics_id,
      visitor_source,
      conv_1_life,
      #session_grp,
      sum(session_grp) OVER (PARTITION BY user_analytics_id ORDER BY Start_Time) session_cumsum
    FROM `festive-radar-307222.mta_data.mta_data_agg_0`)
  GROUP BY user_analytics_id, session_cumsum
  ORDER BY session_cumsum
)
;