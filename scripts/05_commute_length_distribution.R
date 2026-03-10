library(ggplot2)
library(dplyr)
library(scales)
library(tidyverse)


# 1. 加载数据
df <- read.csv("../data/processed/casual&weekday_duration_distribution.csv")

# 2. 计算累计占比
duration <- df %>%
  arrange(duration_min) %>%
  mutate(cum_sum = cumsum(ride_count),
         cum_perc = cum_sum / sum(ride_count))

# 3. 找到 20 分钟处的累计百分比数值
ref_val <- duration %>% 
  filter(duration_min <= 20) %>% 
  tail(1) %>% 
  pull(cum_perc)
perc_label <- paste0("累计占比: ", round(ref_val * 100, 1),"%")

# print(perc_label)  "累计占比: 76.4%"

# 4. 开始绘图
ggplot(duration, aes(x = duration_min, y = ride_count)) +
  geom_col(fill = "#479FF8", alpha = 0.8) +
  coord_cartesian(xlim = c(0, 90)) +                                                            # 只看前90分钟，否则长尾太长看不清
  geom_vline(xintercept = 20, color = "red", linetype = "dashed", size = 0.5) +
  annotate("text", x = 23, y = max(duration$ride_count)*0.8,                                    # 添加标注文字
           label = perc_label, color = "red", hjust = 0, fontface = "bold") +
  scale_x_continuous(breaks = seq(0, 3600, 600), labels = function(x) paste0(x/60, "min")) +    # 格式化轴标签
  scale_y_continuous(labels = comma) + 
  labs(title = "工作日休闲用户骑行时长分布 (0-90分钟)",                                          # 图表标题
       subtitle = "红色虚线标注了 20 分钟的短途时长上限",
       x = "骑行时长 (分钟)",
       y = "骑行次数 (Count)") +
  theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5, size = 10, color = "gray50"))
