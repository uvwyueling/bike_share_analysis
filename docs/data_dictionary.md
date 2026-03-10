# 数据字典  -  Cyclistic 骑行数据（ 20241201 ~ 20251130 ）

## 1. 原始数据表 （ trip_data_raw）

| 字段名 | 类型 | 说明 | 备注 |
| :--- | :--- | :--- | :--- |
| ride_id | STRING | 骑行唯一标识符 | 主键，不可重复 |
| rideable_type | STRING | 自行车类型 | classic_bike, electric_bike |
| started_at | TIMESTAMP | 租借开始时间 | UTC 时间 |
| ended_at | TIMESTAMP | 租借结束时间 | UTC 时间 |
| start_station_name | STRING | 起点站名称 | 约 21% 缺失 <br> (电单车无桩停放业务性质导致，非系统错误) |
| start_station_id | STRING | 起点站编号 | 约 21% 缺失 <br>(电单车无桩停放业务性质导致，非系统错误) |
| end_station_name | STRING | 终点站名称 | 约 22.2% 缺失 <br>(22.1% 为电单车无桩停放业务性质导致，非系统错误;<br> 0.1% 为经典单车异常事件导致数据缺失)|
| end_station_id | STRING | 终点站编号 | 约 22.2% 缺失 <br>(22.1% 为电单车无桩停放业务性质导致，非系统错误;<br> 0.1% 为经典单车异常事件导致数据缺失)|
| start_latFLOAT | ROUND(,2)度 | 无数据缺失 |
| start_lng | FLOAT | 起点站经度 | 无数据缺失 |
| end_lat | FLOAT | 终点站纬度 | 约 0.1% 缺失<br>（均为经典单车异常事件导致数据缺失） |
| end_lng | FLOAT | 终点站经度 | 约 0.1% 缺失<br>（均为经典单车异常事件导致数据缺失） |
| member_casual | STRING| 用户类别 | member, casual |



## 2. 清洗后数据表  （ clean_trip_data）

| 字段名 | 类型 | 业务逻辑 | 目的 | 备注 |
| :--- | :--- | :--- | :--- | :--- |
| ride_length_seconds | INTEGER | TIMESTAMP_DIFF(ended_at, started_at, SECOND) | 计算行程时长 | 约2.63%的行程时间异常<br>（时长为负值或小于60秒） |
| day_of_week | STRING | FORMAT_TIMESTAMP('%A', started_at) | 提取星期维度，用于后续区分工作日/周末潮汐现象 |   |
| grid_start_lat | FLOAT | ROUND(start_lat,2) | 统一底层空间口径 | 因电单车无桩停放导致起终点经纬度仅精确到小数点后两位 |
| grid_start_lng | FLOAT | ROUND(start_lng,2) | 统一底层空间口径 | 因电单车无桩停放导致起终点经纬度仅精确到小数点后两位 |
| grid_end_lat | FLOAT | ROUND(end_lat,2) | 统一底层空间口径 | 因电单车无桩停放导致起终点经纬度仅精确到小数点后两位 |
| grid_end_lng | FLOAT | ROUND(end_lng,2) | 统一底层空间口径 | 因电单车无桩停放导致起终点经纬度仅精确到小数点后两位 |