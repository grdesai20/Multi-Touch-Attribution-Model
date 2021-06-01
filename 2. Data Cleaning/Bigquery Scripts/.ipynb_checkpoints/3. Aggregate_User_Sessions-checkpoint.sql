#User level agg 0

'''
Once we have created unique sessions, we identified multiple interactions of every user in every session. 

In Aggregation, we have aggregated the interactions each user had within each session. This could also be thought of as removing duplicates. (group by)


In the following code, we now have a unique entry for each user based on user_analytics_id, Date, session_id, user_agent, referred_to_url, product_visited, and visitor_source columns. The result of the script would be stored in a BigQuery table named mta_data_agg_0.

'''





CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_agg_0 AS 
(
  SELECT
    d1.user_analytics_id,
    d1.Date, 
    d1.user_agent, 
    d1.referred_to_url, 
    d1.product_visited,
    MIN(d1.created_at) Start_Time,
    MAX(d1.created_at) End_Time,
    #MAX(d1.visitor_source) visitor_source,
    visitor_source,
    MAX(d1.conv_1_life) conv_1_life,
    MAX(d1.conv_1_life_date) conv_1_life_date,
    MAX(d1.conv_2_life) conv_2_life,
    MAX(d1.conv_2_life_date) conv_2_life_date,
    MAX(d1.conv_3_life) conv_3_life,
    MAX(d1.conv_3_life_date) conv_3_life_date,
    MAX(exit_survey_source_category) exit_survey_source_category,
    MAX(exit_survey_submitted_product) exit_survey_submitted_product,
    MAX(exit_survey_source) exit_survey_source,
    d1.session_id,
    IF(lag(visitor_source) OVER (PARTITION BY user_analytics_id ORDER BY MIN(d1.created_at)) = visitor_source, 0, 1) session_grp
  FROM 
    `festive-radar-307222.mta_data.mta_data_session` d1
  GROUP BY 
    d1.user_analytics_id, d1.Date, session_id, d1.user_agent, d1.referred_to_url, d1.product_visited, visitor_source
  ORDER BY 
    d1.user_analytics_id, MIN(d1.created_at) #, visitor_source
)
;