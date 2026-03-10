library(geohashTools)
library(dplyr)
library(tidyverse)
library(ggplot2)

morning <- read_csv("../data/processed/casual_weekday_7_9am_end_location.csv")
afternoon <- read_csv("../data/processed/casual_weekday_4_6pm_start-location.csv")

# 1. 设置 Geohash 精度
precision_level <- 6 

# 2. 提取并转换早高峰终点 (AM Drop-off) 和晚高峰起点 (PM Pick-up)
am_dropoff <- morning %>% 
  mutate(geohash = gh_encode(grid_lat, grid_lng, precision_level))

pm_pickup <- afternoon %>% 
  mutate(geohash = gh_encode(grid_lat, grid_lng, precision_level))

# 3. 提取唯一的 Geohash 集合
set_am <- unique(am_dropoff$geohash)
set_pm <- unique(pm_pickup$geohash)

# 4. 计算杰卡德对比 (Jaccard Index)
intersection_size <- length(intersect(set_am, set_pm))
union_size <- length(union(set_am, set_pm))

jaccard_score <- intersection_size / union_size

print(paste("基于 Geohash 的早晚高峰重合度为:", round(jaccard_score, 4)))

# 返回结果："基于 Geohash 的早晚高峰重合度为: 0.7837"


