'''突变位点landscape图
'''
'''利用landscape_file.py生成的文件，作为输入文件
'''

library(ComplexHeatmap)

setwd("C:/Users/dell/desktop")
infile = read.table("landscape_filter_gene.plot.xls", sep="\t",header=TRUE, row.names = 1)

infile[is.na(infile)] = ""

#rownames(infile) =infile[,1] 
#infile1 =infile[,2:32]

col = c("missense" = "blue", "stopgain" = "red", "unknown" = "orange")

'''由于测试数据集只有miss和stop，所以只定义了这2个的function
'''
alter_fun = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(1.0, "mm"), h-unit(1.0, "mm"), gp = gpar(fill = "#CCCCCC", col = NA))
  },

  stopgain = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.8, "mm"), h-unit(3.0, "mm"), gp = gpar(fill = col["stopgain"], col = NA))
  },
    missense = function(x, y, w, h) {
    grid.rect(x, y, w-unit(3.0, "mm"), h-unit(0.8, "mm"), gp = gpar(fill = col["missense"], col = NA))
  },
  unknown = function(x, y, w, h) {
    grid.rect(x, y, w-unit(1.5, "mm"), h-unit(1.5, "mm"), gp = gpar(fill = col["unknown"], col = NA))
  }
)

oncoPrint(infile, get_type = function(x) strsplit(x, ",")[[1]],
        alter_fun = alter_fun, col = col, 
        #row_order = NULL,  #定义百分数排序
        # pct_gp = gpar(col="white",fontsize = 0.01), row_names_gp = gpar(fontsize = 12),row_names_side = "left",
        # column_title = "",column_title_gp=gpar(fontsize=10),show_row_barplot =FALSE ,
        # show_column_names = TRUE,show_heatmap_legend=T,
        # column_names_gp=gpar(fontsize = 12),
          remove_empty_columns = TRUE,
          show_pct = TRUE, 
          pct_gp = gpar(fontsize = 5),
          row_names_gp = gpar(fontsize = 8),
          show_row_barplot = FALSE,
          #row_names_side = "left", 
          column_title = "Landscape of RA_ILD",
          show_column_names = TRUE,show_heatmap_legend=T,
        column_names_gp=gpar(fontsize = 6),
          heatmap_legend_param = list(title = "Alternations", at = c("missense", "stopgain", "unknown"), labels = c("missense","stopgain", "unknown")))

