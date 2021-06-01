#User level agg 2

'''
This is the final aggregation step tp create the user journey which comprises all marketing channels that a user has been through and whether or not that user has converted. 

For each marketing channel subset, we’ll find out how many conversions (conv_1_life column) and non-conversions (total_null column) has been derived from that channel. 

The result of the script would be stored in a BigQuery table named mta_data_agg_2. 

This step is optional since we have done this aggregation in Jupyter notebooks also for quick analysis through pandas.

'''




CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_agg_2 AS 
(
  SELECT 
    marketing_channel_subset,
    SUM(conv_1_life) conv_1_life,
    SUM(total_null) total_null
  FROM (SELECT
      user_analytics_id,
      STRING_AGG(visitor_source, ' > ') marketing_channel_subset,
      MAX(conv_1_life) conv_1_life,
      SUM(IF(conv_1_life = 0, 1, 0)) total_null
    FROM `festive-radar-307222.mta_data.mta_data_agg_0`
      GROUP BY user_analytics_id) tmp
  GROUP BY marketing_channel_subset
)
;