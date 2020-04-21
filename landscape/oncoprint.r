'''oncoprint的用法说明
'''

'''oncoPrint(mat, get_type = function(x) x,alter_fun = alter_fun_list, alter_fun_list = NULL, col,row_order = oncoprint_row_order(),column_order = oncoprint_column_order(),show_column_names = FALSE,show_pct = TRUE, pct_gp = gpar(), pct_digits = 0,....)
'''
'''
mat:类别矩阵。

get_type:得到数据中的类别。

alter_fun:函数list，具体说明每个类别要怎么画。

col:图例的颜色
'''


#step1
'''写脚本，叫数据转换为符合要求的mat格式
'''
 
 '''
输入文件格式：2种
 '''

 mat = read.table(textConnection(
     ", s1, s2, s3
     g1,snv;indel, snv, indel
     g2,snv;inde;,snv
     g3,snv, ,indel;snv"
 ), row.names=1 , header=TRUE, sep = ",", stringsAsFactor= FALSE)

 mat = as.matrix(mat)

#  mat 

#  '''
#        s1          s2          s3         
#     g1 "snv;indel" "snv"       "indel"    
#     g2 ""          "snv;indel" "snv"      
#     g3 "snv"       ""          "indel;snv"

#  '''

# library(ComplexHeatmap)
# col = c(snv = "red", indel = "blue")
# oncoPrint(mat, get_type = function(x) strsplit(x, ";")[[1]],
#     alter_fun = list(
#         snv = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = col["snv"], col = NA)),
#         indel = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.4, gp = gpar(fill = col["indel"], col = NA))
#     ), col = col)

# #strsplit:定义样本中基因的突变类型的分割符，

###########################################################################################

'''输入文件的第2种格式，利用0,1表示矩阵
'''
mat_list = list(snv = matrix(c(1, 0, 1, 1, 1, 0, 0, 1, 1), nrow = 3),
                indel = matrix(c(1, 0, 0, 0, 1, 0, 1, 0, 0), nrow = 3))
rownames(mat_list$snv) = rownames(mat_list$indel) = c("g1", "g2", "g3")
colnames(mat_list$snv) = colnames(mat_list$indel) = c("s1", "s2", "s3")
mat_list

'''
$snv
   s1 s2 s3
g1  1  1  0
g2  0  1  1
g3  1  0  1

$indel
   s1 s2 s3
g1  1  0  1
g2  0  1  0
g3  0  0  0
'''

#对于第2种，需要格式统一；
'''
函数：unify_mat_list()
'''

mat_list2 = mat_list
mat_list2$indel = mat_list2$indel[1:2, 1:2]
mat_list2

'''
$snv
   s1 s2 s3
g1  1  1  0
g2  0  1  1
g3  1  0  1

$indel
   s1 s2
g1  1  0
g2  0  1
'''

mat_list2 = unify_mat_list(mat_list2)
mat_list2

'''
$snv
   s1 s2 s3
g1  1  1  0
g2  0  1  1
g3  1  0  1

$indel
   s1 s2 s3
g1  1  0  0
g2  0  1  0
g3  0  0  0
'''

# oncoPrint(mat_list,
#     alter_fun = list(
#         snv = function(x,y,w,h) grid.rect(x,y,w*0.9,h*0.9, gp = gpar(fill = col["SNV"], col = NA)),
#         indel = function(x,y,w,h) grid.rect(x,y,w*0.9, h*0.4, gp = gpar(fill = col["indel"], col = NA))
#     ),
#     col = col
#     )

'''
alter_fun:是一个逐层添加图形的方式，
还可以通过指定单个函数，逐个网格样式添加图形，区别在于需要接受第5个参数：single function
'''
# oncoPrint(mat_list,
#     alter_fun = function(x, y, w, h, v) {
#         if(v["snv"]) grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = col["snv"], col = NA))
#         if(v["indel"]) grid.rect(x, y, w*0.9, h*0.4, gp = gpar(fill = col["indel"], col = NA))
#     }, col = col)


# #绘制个性化，图层的宽度自适应
# oncoPrint(mat_list,
#     alter_fun = function(x, y, w, h, v) {
#         n = sum(v)
#         h = h*0.9
#         # use `names(which(v))` to correctly map between `v` and `col`
#         if(n) grid.rect(x, y - h*0.5 + 1:n/n*h, w*0.9, 1/n*h, 
#             gp = gpar(fill = col[names(which(v))], col = NA), just = "top")
#     }, col = col)

'''通过alter_fun，可以自己定义不同突变的特质,没怎么看懂
'''

# snv_fun = function(x,y,w,h) {
#     grid.rect(x,y,w,h, gp =gpar(fill = col["snv"], col = "NA"))
# }

# indel_fun = function(x,y,w,h) {
#     grid.rect(x,y,w,h, gp = gpar(fill = col["indel"], col = "NA"))
# }

# snv_fun = function(x, y, w, h) {
#     grid.rect(x, y, w, h, gp = gpar(fill = col["snv"], col = NA))
# }

# indel_fun = function(x, y, r) {
#     grid.circle(x, y, r, gp = gpar(fill = col["indel"], col = NA))
# }

# oncoPrint(mat, get_type = function(x) strsplit(x, ";")[[1]],
#     alter_fun = function(x, y, w, h, v) {
#         n = sum(v)
#         w = convertWidth(w, "cm")*0.9
#         h = convertHeight(h, "cm")*0.9
#         l = min(unit.c(w, h))

#         grid.rect(x, y, w, h, gp = gpar(fill = "grey", col = NA))

#         if(n == 0) return(NULL)
#         if(n == 1) {
#             if(names(which(v)) == "snv") snv_fun(x, y, l, l)
#             if(names(which(v)) == "indel") indel_fun(x, y, l*0.5)
#         } else if(n == 2) {
#             snv_fun(x, y-0.25*h, l, l)
#             indel_fun(x, y+0.25*h, l*0.5)
#         }
#     }, col = col)

'''定义alter_fun list，需要注意定义的顺序，这个和图层的绘制间存在关系，需要注意
'''

# col = c("snv" = "blue", "indel" = "red")

# oncoPrint(mat_list,
#     alter_fun = list(
#         background = function(x,y,w,h) grid.rect(x,y,w,h, gp = gpar(fill = "#00FF0020")),
#         snv = function(x,y,w,h) grid.rect(x,y,w,h), gp = gpar(fill = col["snv"], col = NA),
#         indel = function(x,y,w,h) grid.rect(x,y,w,h), gp = gpar(fill = col["indel"], col =NA)),
#         col = col 
#         )


'''alter_fun：通过第五个变量v（逻辑变量），判断是否存在该突变形式
'''
# oncoPrint(mat,
#     alter_fun = function(x, y, w, h, v) {
#         if(v["snv"]) grid.rect(x, y, w*0.9, h*0.9, # v["snv"] is a logical value
#             gp = gpar(fill = col["snv"], col = NA))
#         if(v["indel"]) grid.rect(x, y, w*0.9, h*0.4, # v["indel"] is a logical value
#             gp = gpar(fill = col["indel"], col = NA))
#     }, col = col)

'''如果alter_fun指定为一个list， 必须指定background参数，且必须为第一个参数 
'''

# oncoPrint(mat,  
#     alter_fun = list(
#         background = function(x, y, w, h) grid.rect(x, y, w, h, 
#             gp = gpar(fill = "#00FF0020")),
#         snv = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, 
#             gp = gpar(fill = col["snv"], col = NA)),
#         indel = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.4, 
#             gp = gpar(fill = col["indel"], col = NA))
#     ), col = col)

# #去掉背景设置

# oncoPrint(mat,
#     alter_fun = list(
#         background = function(...) NULL,
#         snv = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, 
#             gp = gpar(fill = col["snv"], col = NA)),
#         indel = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.4, 
#             gp = gpar(fill = col["indel"], col = NA))
#     ), col = col)


'''个性化绘制基因突变热图， 即表明突变类型，也表明突变发生的位置信息
'''

##定义数据集
set.seed(123)
x1 = sample(c("", "snv"), 100, replace = TRUE, prob = c(8, 2))
x2 = sample(c("", "indel"), 100, replace = TRUE, prob = c(8, 2))
x2[x1 == "snv"] = ""
x3 = sample(c("", "intronic"), 100, replace = TRUE, prob = c(5, 5))
x4 = sample(c("", "exonic"), 100, replace = TRUE, prob = c(5, 5))
x3[x1 == "" & x2 == ""] = ""
x4[x1 == "" & x2 == ""] = ""
x4[x3 == "intronic"] = ""
x = apply(cbind(x1, x2, x3, x4), 1, function(x) {
    x = x[x != ""]
    paste(x, collapse = ";")
})
m = matrix(x, nrow = 10, ncol = 10, dimnames = list(paste0("g", 1:10), paste0("s", 1:10)))
m[1:4, 1:4]

##定义绘图参数
alter_fun = list(
    background = function(x, y, w, h) 
        grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = "#CCCCCC", col = NA)),
    # red rectangles
    snv = function(x, y, w, h) 
        grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = "red", col = NA)),
    # blue rectangles
    indel = function(x, y, w, h) 
        grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = "blue", col = NA)),
    # dots
    intronic = function(x, y, w, h) 
        grid.points(x, y, pch = 16),
    # crossed lines
    exonic = function(x, y, w, h) {
        grid.segments(x - w*0.4, y - h*0.4, x + w*0.4, y + h*0.4, gp = gpar(lwd = 2))
        grid.segments(x + w*0.4, y - h*0.4, x - w*0.4, y + h*0.4, gp = gpar(lwd = 2))
    }
)

##绘图
# we only define color for snv and indel, so barplot annotations only show snv and indel
ht = oncoPrint(m, alter_fun = alter_fun, col = c(snv = "red", indel = "blue"))
draw(ht, heatmap_legend_list = list(
    Legend(labels = c("intronic", "exonic"), type = "points", pch = c(16, 28))
))

##不知道是否是版本问题，报错

oncoPrint(mat, get_type = function(x) strsplit(x, ';')[[1]],
    alter_fun = alter_fun, col = col, 
    top_annotation = HeatmapAnnotation(
        column_barplot = anno_oncoprint_barplot("MUT", border = TRUE, height = unit(4, "cm"))),
    
    remove_empty_columns = TRUE, remove_empty_rows = TRUE,
    column_title = column_title, heatmap_legend_param = heatmap_legend_param)




oncoPrint(mat,
    alter_fun = alter_fun, col = col, 
    remove_empty_columns = TRUE, remove_empty_rows = TRUE,
    column_title = column_title, heatmap_legend_param = heatmap_legend_param,
    left_annotation = rowAnnotation(
       rbar = anno_oncoprint_barplot(
          axis_param = list(direction = "reverse")
       )),
       right_annotaion = NULL)


oncoPrint(mat, alter_fun = alter_fun, col = col, 
    left_annotation =  rowAnnotation(
        rbar = anno_oncoprint_barplot(
            axis_param = list(direction = "reverse")
    )),
    right_annotation = NULL, name = "test1")



oncoPrint(mat, alter_fun = alter_fun, col = col, show_row_names = FALSE, name = "test2")

