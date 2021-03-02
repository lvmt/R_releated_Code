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

col = c("cds_indel" = "lightblue", "frameshift" = "yellow", "missense" = "orange",
        'nonsense'='green', 'misstart'='purple', 'splice'='black', 'stop_gain'='red',
        'stop_loss'='blue')

'''由于测试数据集只有miss和stop，所以只定义了这2个的function
'''

alter_fun = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(1.0, "mm"), h-unit(1.0, "mm"), gp = gpar(fill = "#CCCCCC", col = NA))
  },
  cds_indel = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.1, "mm"), h-unit(3.0, "mm"), gp = gpar(fill = col["cds_indel"], col = NA))
  },
  frameshift = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.2, "mm"), h-unit(0.2, "mm"), gp = gpar(fill = col["frameshift"], col = NA))
  },
  missense = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.3, "mm"), h-unit(0.4, "mm"), gp = gpar(fill = col["missense"], col = NA))
  },
  misstart = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.4, "mm"), h-unit(0.4, "mm"), gp = gpar(fill = col["misstart"], col = NA))
  },
  nonsense = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.6, "mm"), gp = gpar(fill = col["nonsense"], col = NA))
  },
  stopgain = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.6, "mm"), h-unit(0.8, "mm"), gp = gpar(fill = col["stop_gain"], col = NA))
  },
  stoploss = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.7, "mm"), h-unit(1.5, "mm"), gp = gpar(fill = col["stop_loss"], col = NA))
  },
  splice = function(x, y, w, h) {
    grid.rect(x, y, w-unit(1.5, "mm"), h-unit(1.5, "mm"), gp = gpar(fill = col["splice"], col = NA))
  }
)

oncoPrint(infile, get_type = function(x) strsplit(x, ";")[[1]],
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
          #show_row_barplot = FALSE,
          #row_names_side = "left", 
          column_title = "Landscape of RA_ILD",
          show_column_names = TRUE,show_heatmap_legend=T,
        column_names_gp=gpar(fontsize = 6),
          heatmap_legend_param = list(title = "Alternations",
          at = c("cds_indel", "frameshift", "missense", "misstart", "nonsense", "stop_gain", "stop_loss", "splice"),
          labels = c("cds_indel", "frameshift", "missense", "misstart", "nonsense", "stop_gain", "stop_loss", "splice")))

