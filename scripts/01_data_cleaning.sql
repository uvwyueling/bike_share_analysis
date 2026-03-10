CREATE OR 
REPLACE TABLE `bike_sharing.clean_trip_data` AS
SELECT 
    *,
    TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_length_seconds,    -- 1. 计算两个时间戳之间的时间差
    FORMAT_TIMESTAMP('%A', started_at) AS day_of_week,                      -- 2. 提取星期维度，用于后续区分工作日/周末潮汐现象
    ROUND(start_lat,2) AS grid_start_lat,                                    --3. 统一底层空间口径
    ROUND(start_lng,2) AS grid_start_lng,                                     -- （因电单车无桩停放导致起终点经纬度仅精确到小数点后两位）
    ROUND(end_lat,2) AS grid_end_lat,
    ROUND(end_lng,2) AS grid_end_lng
FROM bike_sharing.trip_data_202412-202511
WHERE 
    NOT (rideable_type = 'classic_bike' AND end_station_name IS NULL)       -- 4. 过滤掉 (rideable_type 是 classic_bike 且 end_station_name 为空) 的行，以剔除异常座标
    AND TIMESTAMP_DIFF(ended_at, started_at, SECOND) BETWEEN 61 AND 86400   -- 5. 只选取行程时长大于60秒同时小于24小时的行程数据
                                                                               -- 行程时长小于60秒的行程是物理异常、与业务无效的错误启动
                                                                               -- 行程时长超过24小end超lng