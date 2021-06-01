#User level session

'''

For each user, we have created separate sessions based on their inactivity on the page. For example, if a user is inactive for more than 30 mins, we tag his next interaction as a new session. 

This code assigns a session id in an incremental format for each user based on the time difference between their consecutive interactions. Also, we assume that a new session starts with a new day.  The result of the script would be stored in a table named mta_data_session.



'''


CREATE OR REPLACE TABLE festive-radar-307222.mta_data.mta_data_session AS 
(
  SELECT
    d1.*,
    session_id
  FROM 
    `festive-radar-307222.mta_data.mta_data_clean` d1
  LEFT JOIN 
    (SELECT
      user_analytics_id,
      created_at,
      referred_to_url,
      SUM(IF(FLOOR(MIN(time_diff_sec)/60) < 30 OR MIN(time_diff_sec) IS NULL, 0, 1)) OVER (PARTITION BY user_analytics_id, Date ORDER BY created_at) session_id
    FROM `festive-radar-307222.mta_data.mta_data_clean`
    GROUP BY user_analytics_id, created_at, Date, referred_to_url
    ORDER BY user_analytics_id, created_at) d2 
  ON d1.user_analytics_id = d2.user_analytics_id AND d1.created_at = d2.created_at AND d1.referred_to_url = d2.referred_to_url
  ORDER BY 
    d1.user_analytics_id, visitor_source
)
;