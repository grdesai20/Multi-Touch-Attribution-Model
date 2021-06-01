# Policy Genius Data Driven Multi Touch Attribution modeling 

## About 
Policygenius is partnering with NYU to create an MTA model to upgrade our current attribution modeling. This project will span for about 2 months, in which Policygenius mentors and directs the NYU team in creating different machine learning MTA models.


## Objective
The NYU team has built an Multi touch attribution model for the life insurance vertical within the first stage of funnel conversion. The result will be a model describing the defining the attribution of various marketing channels to first stage conversions. This model will include all user touchpoints, and not just first or last touch. The exit survey will also be explored for relevancy. The data spans from March 2020 to March 2021.


## Data Dictionary
user_analytics_id: customer id

user_agent: device, os system, etc. used by customer

referred_to_url: site for touchpoint

created_at: reference date

visitor_source: channel source

conv_#_life: # stage of funnel (#1 is PRIMARY RESPONSE LABEL)

conv_#_life_date: date of conversion

exit_survey_source_category: exit survey response for source

exit_survey_submitted_product: exit survey product type

exit_survey_source: exit source detailed response from source_category

product_visited: product associated with referral site


## Code 
[1] *Data Understanding*

Data Understanding contains Exploratory Analysis and Hypothesis testing that were performed. Initially we explored the the sample data (single file). The final data exploration and understanding on complete data is present in 'Exploratory Data Analysis.ipynb'


[2] *Data Cleaning*

Files contained:

1. Data_Cleaning.ipynb : The file contains all Data Cleaning Strategies:
    - Filling null values:  we replaced null values in exit survey(exit_survey_source_category, exit_survey_submitted_product, exit_survey_source), user_agent and referred_to_url columns with “unknown”. Similarly for conv_1_life, the null values were replaced with 0. We replaced null values in referred_to_url with ‘/’  For entries with visitor_source=”Direct”. 
    
    - Identify the referred_to_url that contains "-life%" and if the product_visited for such URL is not already "auto" or "home" then we can safely categorize them as "Life" in product_visited

    - Sessioning  &  Delete Duplication




2. Big Query (SQL Files):

- Create_User_Session.sql
For each user, we have created separate sessions based on their inactivity on the page. For example, if a user is inactive for more than 30 mins, we tag his next interaction as a new session. The above script assigns a session id in an incremental format for each user based on the time difference between their consecutive interactions. Also, we assume that a new session starts with a new day.  The result of the script would be stored in a BigQuery table named mta_data_session.

- Aggregate_User_Sessions.sql
Once we have created unique sessions, we identified multiple interactions of every user in every session. In Aggregation, we have aggregated the interactions each user had within each session. This could also be thought of as removing duplicates. In the above code, we now have a unique entry for each user based on user_analytics_id, Date, session_id, user_agent, referred_to_url, product_visited, and visitor_source columns. The result of the script would be stored in a BigQuery table named mta_data_agg_0.

- Group_consecutive_channel.sql
Since we already have session ids for each customer session in place which indicates a changed session. Now, we create the running sum (creating a session_cumsum column) for the user session ids in order to get the distinctive sessions for the whole marketing journey of the user in an incremental manner. The result of the script would be stored in a BigQuery table named mta_data_agg_1.


-  Aggregate_User_Path.sql
This will create the user journey which comprises all marketing channels that a user has been through and whether or not that user has converted. Then, for each marketing channel subset, we’ll find out how many conversions (conv_1_life column) and non-conversion (total_null column) have been derived from that channel. The result of the script would be stored in a BigQuery table named mta_data_agg_2. This step is optional since we have done this aggregation in Jupyter notebooks also for quick analysis through pandas.






[3] *Model Building*

- Final_Model_Development.ipynb: Contains the Implementation of all the models.

1. First Touch Model
2. Last Touch Model
3. Linear Model
4. Markov Chain Model
5. Shapely Value Model



## Issues Handled
Duplicate issues: website redirecting creates additional touchpoints within a short timeframe (< 1 minute). These should were investigated and filtered. 

Product type: This column as used as a rough estimate for the non-conversion product type. Example: a touchpoint labeled "life" can be thought of as a life customer. Notably, customers can visit more than one product per journey. Therefore, this column should be used with caution and is not definitive. We identified code change to identify the life vertical blogs and categorize them as 'life' which were earlier identified as 'others'





## Code changes for Product_visited column
```
WHEN referred_to_url like ‘%/life-insurance% THEN ‘life’
WHEN referred_to_url like ‘%/home-insurance% THEN ‘home’
WHEN referred_to_url like ‘%/auto-insurance% THEN ‘auto’
WHEN (referred_to_url is 'other') AND (referred_to_url like ‘%-life%) THEN ‘life’
ELSE ‘other’
```



## Final Steps

Step 1: Run Data Cleaning files 

<u> In Data Cleaning folder </u>


Handle_Null_Value.sql --> Create_User_Session.sql --> Aggregate_User_Sessions.sql -->  Group_consecutive_channel.sql -->  Aggregate_User_Path.sql


Step 2: Implement the Models using Jupyter Notebook

<u> In Model Development folder </u>

Final_Model_Development.ipynb


