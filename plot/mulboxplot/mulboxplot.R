library(readxl)
library(ggplot2)
library(reshape)
library(dplyr)

setwd('C:/Users/DELL/desktop')
data <- read_excel('gene.xlsx')  # 读取excel表格
df <- data.frame(data)
dfs <-  df[, c(2,3,4,5,6,7,8)]

res <- melt(dfs, id=c('method'))  # 数据融合
names(res) <- c('method', 'gene', 'nums')

# 指定x轴输出顺序
res$method <- factor(res$method, levels = c('control', 'BGIandNWZ', 'BGI' , 'NWZreagent', 'NWZbeads'), ordered = TRUE)
# 绘图
ggplot(res, aes(x = method, y = nums)) +
  geom_boxplot(aes(fill = gene),position=position_dodge(0.7),width=0.6) + 
  theme(axis.text = element_text(size = 15))



