
-- 1. 提取“工作日通勤特征占休闲行程比例”的漏斗查询

SELECT  
    COUNT(*) AS casual_commute_trips
FROM `bike_sharing.casual_user_weekday`
WHERE 
    ride_length_seconds <= 1200                             -- 限定骑行时长在20分钟以内的行程
    AND (
      (EXTRACT(HOUR FROM started_at) BETWEEN 7 AND 8)       -- 限定骑行始于上午7-8点或下午4-5点的行程（早高峰与晚高峰）
      OR
      (EXTRACT(HOUR FROM started_at) BETWEEN 16 AND 17)
    )




--2. 聚合计算休闲用户一天24小时的骑行量（对比工作日和周末）
SELECT  
       
    (CASE 
        WHEN day_of_week NOT IN ('Saturday','Sunday')
        THEN 'Weekday'
        ELSE 'Weekend'
    END) AS week_tag,                                        --给工作日和周末分类
    EXTRACT(HOUR FROM started_at) AS hour_of_day,            --提取借车时间点的小时数字
    COUNT(*) AS ride_count
FROM `bike_sharing.clean_trip_data`
WHERE 
    member_casual = 'casual'
GROUP BY 1,2
ORDER BY 2   

-- 得到输出表格：工作日和周末每小时的休闲骑行数量，用于后续绘制折线图以支撑“骑行频次在早晚时段呈现显著的双峰分布（工作日早/晚高峰）”



--3. 计算骑行时长分布直方图底层数据的代码
SELECT 
    ROUND((ride_length_seconds/60),0) AS duration_min,   -- 按分钟聚合,取整数
    COUNT(*) AS ride_count,
FROM 
    `bike_sharing.casual_user_weekday`
GROUP BY 
    1
ORDER BY 
    1

-- 得到输出表格：工作日休闲骑行行程时长分布（按分钟聚合），用于后续绘制直方图以支持“通勤的休闲用户单次骑行时长高度集中在 20 分钟以内”
