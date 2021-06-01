CREATE OR REPLACE EXTERNAL TABLE `festive-radar-307222.mta_data.mta_data`
OPTIONS (
  format = 'CSV',
  uris = ['https://drive.google.com/open?id=1lTDNNC_9aUQkTkep5XsyfTtVHpg7VAij',
          'https://drive.google.com/open?id=1C1fge2JoIM3xyKj_e3_ut-9bI2SFjoCc',
          'https://drive.google.com/open?id=1aFjf23sIbwWSZ03XjJ1sOJSYKv6Xx0Pz',
          'https://drive.google.com/open?id=13HpjpScnIuJYQs4TZ8wxy3HHAMFcQyLm',
          'https://drive.google.com/open?id=1TmLkjU85INNnHAgmjesMesk41Csj1nzq',
          'https://drive.google.com/open?id=1jLvhfKVhXhKPiHwXMuw6luLMLcTiKUT_',
          'https://drive.google.com/open?id=1VramTMSi1koyo5p7QwikxJcVif-9SXgg',
          'https://drive.google.com/open?id=1QvRcFGdEGR3_xHk-uxRVJfGijWXmCAVk',
          'https://drive.google.com/open?id=1sr3ihh5vc3ckkhUuf1X32g8w19WTIViu',
          'https://drive.google.com/open?id=1-cPpOtckdwzQ2JjT58Y_50cS6vfZeS7t'
          ],
  skip_leading_rows = 1
);
