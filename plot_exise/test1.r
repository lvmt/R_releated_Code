
library(ComplexHeatmap)
require(circlize)

'''输入文件类容：

Sample  Gene    Alteration  Type
TCGA-2Y-A9GW-01 FLT3    UP  EXP
TCGA-2Y-A9GY-01 FLT3    UP  EXP
TCGA-2Y-A9H2-01 FLT3    UP  EXP
TCGA-2Y-A9H7-01 FLT3    DOWN    EXP
TCGA-5C-A9VG-01 FLT3    DOWN    EXP
TCGA-5C-A9VH-01 FLT3    DOWN    EXP
TCGA-5R-AA1C-01 FLT3    DOWN    EXP
TCGA-5R-AA1D-01 FLT3    UP  EXP
TCGA-BC-4072-01 FLT3    UP  EXP
TCGA-BC-A10Q-01 FLT3    DOWN    EXP
TCGA-BC-A10W-01 FLT3    DOWN    EXP
TCGA-BC-A110-01         
TCGA-BC-A5W4-01         
TCGA-BC-A69H-01         
TCGA-BD-A3ER-01         
TCGA-BW-A5NQ-01
'''


'''定义颜色已经每个分类的处理
'''

alter_fun = list(
    EXP = function(x,y,w,h) {
        grid.rect(x,y,w*0.9,h*0.9, gp = gpar(fill="black", col =NA))
    },
    UP = function(x,y,w,h) {
        grid.rect(x,y,w*0.9,h*0.9, gp = gpar(fill="forestgreen", col = NA))
    },
    DOWN = function(x,y,w,h) {
        grid.rect(x,y,w*0.9,h*0.9 gp = gpar(fill = "purple", col=NA))
    }
)

cols = c("EXP" = "black", "DOWN" = "forestgreen", "UP" = "purple")

onco <- oncoPrint(df[,2:3])

'''plot annotations separately
'''
onco <- oncoPrint(df[,2:3],
    name="MyOncoprint",
    alter_fun=alter_fun,
    col=cols,
    remove_empty_columns=FALSE,

    row_title="Row title",
    row_title_side="left",
    row_title_gp=gpar(fontsize=15, fontface="bold"),
    show_row_names=TRUE,
    row_names_gp=gpar(fontsize=16, fontface="bold"),
    row_names_max_width=unit(6, "cm"),

    column_title="Column title",
    column_title_side="top",
    column_title_gp=gpar(fontsize=15, fontface="bold"),
    column_title_rot=0,
    show_column_names=TRUE,
    column_names_gp=gpar(fontsize=15, fontface="bold"),

    pct_gp=gpar(fontsize=15, fontface="bold", fill="white", col="white"),
    axis_gp=gpar(fontsize=15, fontface="bold"),

    heatmap_legend_param=list(
        title="My legend",
        title_gp=gpar(fontsize=15, fontface="bold"),
        at=c("EXP", "UP", "DOWN"),
        labels=c("EXP", "UP", "DOWN"),
        labels_gp=gpar(fontsize=15, fontface="bold"),
        nrow=1,
        title_position="topcenter"))

draw(onco, heatmap_legend_side="top", annotation_legend_side="bottom", newpage=FALSE)

'''merge the annotations ans split by semi-colon

   add a single extra parameter to oncoPrint(): get_type
'''

df.new <- df
df.new$AlterationType <- apply(df.new, 1, function(x) paste(x[2], x[3], sep=";"))
df.new <- data.frame(df.new[,4], row.names=rownames(df))
colnames(df.new) <- "AlterationType"

onco <- oncoPrint(df.new,
    get_type=function(x) strsplit(x, ";")[[1]],

    name="MyOncoprint",
    alter_fun=alter_fun,
    col=cols,
    remove_empty_columns=FALSE,

    row_title="Row title",
    row_title_side="left",
    row_title_gp=gpar(fontsize=15, fontface="bold"),
    show_row_names=TRUE,
    row_names_gp=gpar(fontsize=16, fontface="bold"),
    row_names_max_width=unit(6, "cm"),

    column_title="Column title",
    column_title_side="top",
    column_title_gp=gpar(fontsize=15, fontface="bold"),
    column_title_rot=0,
    show_column_names=TRUE,
    column_names_gp=gpar(fontsize=15, fontface="bold"),

    pct_gp=gpar(fontsize=15, fontface="bold", fill="white", col="white"),
    axis_gp=gpar(fontsize=15, fontface="bold"),

    heatmap_legend_param=list(
        title="My legend",
        title_gp=gpar(fontsize=15, fontface="bold"),
        at=c("EXP", "UP", "DOWN"),
        labels=c("EXP", "UP", "DOWN"),
        labels_gp=gpar(fontsize=15, fontface="bold"),
        nrow=1,
        title_position="topcenter"))

draw(onco, heatmap_legend_side="top", annotation_legend_side="bottom", newpage=FALSE)
