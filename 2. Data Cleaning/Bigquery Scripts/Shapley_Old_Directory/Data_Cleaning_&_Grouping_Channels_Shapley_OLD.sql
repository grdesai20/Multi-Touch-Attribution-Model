###Objective:This script is mainly for grouping the visitor sources to reduce the total number of marketing channels for shapley value model development.
#Along with the reduction, we are also doing the cleaning (as done earlier)
#Conclusion:Based on PG Recommendation, grouping of visitor sources will be done after data cleaning and after creating all conversion paths for the users.

#SELECT count(*) FROM `festive-radar-307222.mta_data.mta_data`;
#SELECT * FROM `festive-radar-307222.mta_data.INFORMATION_SCHEMA.TABLES`;
# Basic Data Cleaning2: Shapley Values Model

CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_grouping_shapley2 AS 
(
    SELECT
    user_analytics_id,
    IFNULL(user_agent, "unknown") user_agent,
    IF(visitor_source = "Direct", "/", IF(referred_to_url IS NULL, "unknown", IF(NOT(ENDS_WITH(referred_to_url, "/")), CONCAT(referred_to_url, "/"), referred_to_url))) referred_to_url,
    created_at,
    CASE
        WHEN visitor_source in ("Blog", "Organic - SEO", "Organic - Brand") THEN "Organic_Group"
        WHEN visitor_source in ("Personal Referral", "Other", "Lead Gen", "Referral", "Earned Media") THEN "Referral_Group"
        WHEN visitor_source in ("Gmail", "Paid Email","Email") THEN "Email_Group" 
        ELSE visitor_source
        END AS visitor_source,
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
    visitor_source
)
;

########################################################################################################################
#To just cross check the total channels
# SELECT DISTINCT (visitor_source) FROM
# (
# SELECT
#     user_analytics_id,

# CASE
#     WHEN visitor_source in ("Blog", "Organic - SEO", "Organic - Brand") THEN "Organic_Group"
#     WHEN visitor_source in ("Earned Media", "Lead Gen", "Personal Referral", "Referral", "Other") THEN "Referral_Group"
#     WHEN visitor_source in ("Email", "Gmail", "Paid Email") THEN "Email_Group" 
#     WHEN visitor_source in ("Paid Search - B","Paid Search - NB","Paid Social") THEN "Paid_Search_Group" #need to confirm is this can be done!
#     ELSE visitor_source
# END AS visitor_source

# FROM
#     `festive-radar-307222.mta_data.mta_data`
# WHERE
#     created_at >= '2020-03-01 00:00:00 UTC'

# ORDER BY user_analytics_id, visitor_source
# )

########
