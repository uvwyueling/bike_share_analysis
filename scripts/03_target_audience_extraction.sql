-- 目标：提取符合盈亏临界点特征的休闲用户名单，用于自动推送“年度账单”
-- 条件：过去 30 天，工作日早晚高峰，频次 >= 8次，时长 <= 20分钟

WITH Target_Trips AS (
    SELECT 
        user_id,                -- 注：当前开放数据集无此字段
        trip_id,
        ROUND((ride_length_seconds/60),0) AS duration_min
    FROM `clean_trip_data`
    WHERE 
        member_casual = 'casual'
        AND DATE(started_at) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
        AND EXTRACT(DAYOFWEEK FROM started_at) IN (2,3,4,5,6)      -- 工作日
        AND (EXTRACT(HOUR FROM started_at) BETWEEN 7 AND 8 
             OR EXTRACT(HOUR FROM started_at) BETWEEN 16 AND 17)   -- 早晚高峰
        AND ROUND((ride_length_seconds/60),0) <= 20
)

SELECT 
    user_id,
    COUNT(trip_id) AS total_commute_trips,
    SUM(duration_min) AS total_commute_minutes
FROM `Target_Trips`
GROUP BY user_id
HAVING COUNT(trip_id) >= 8;                                         -- 触及财务临界点的频次阈值