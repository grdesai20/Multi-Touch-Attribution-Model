# Basic Data Cleaning


'''

1. Replace the Null Values in referred_to_url with ‘/’   
2. Replace the Null Values in exit_survey_source_category, exit_survey_submitted_product and exit_survey_source with ‘unknown’    
3. Identify the referred_to_url that contains "-life%" and if the product_visited for such URL is not already "auto" or "home" then we can safely categorize them as "Life" in product_visited
4. Create Date and Time from created_at
5. Calculate the timedifference between the consecutive interactions for each user in time_diff_sec


'''




CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_clean AS 
(
  SELECT
    user_analytics_id,
    IFNULL(user_agent, "unknown") user_agent,
    IF(visitor_source = "Direct", "/", IF(referred_to_url IS NULL, "unknown", IF(NOT(ENDS_WITH(referred_to_url, "/")), CONCAT(referred_to_url, "/"), referred_to_url))) referred_to_url,
    created_at,
    visitor_source,
    IFNULL(conv_1_life, 0) conv_1_life,
    conv_1_life_date,
    IFNULL(conv_2_life, 0) conv_2_life,
    conv_2_life_date,
    IFNULL(conv_3_life, 0) conv_3_life,
    conv_3_life_date,
    IFNULL(exit_survey_source_category, "unknown") exit_survey_source_category,
    IFNULL(exit_survey_submitted_product, "unknown") exit_survey_submitted_product,
    IFNULL(exit_survey_source, "unknown") exit_survey_source,
    IF(referred_to_url LIKE "%-life%" AND product_visited = "other", "life", product_visited) product_visited,
    DATE(created_at) Date,
    TIME(created_at) time,
    datetime_diff(created_at, LAG(created_at, 1) OVER (PARTITION BY user_analytics_id, DATE(created_at) ORDER BY created_at), second) as time_diff_sec
  FROM
    `festive-radar-307222.mta_data.mta_data`
  WHERE
    created_at >= '2020-03-01 00:00:00 UTC'
  ORDER BY
    user_analytics_id,
    created_at
)
;
