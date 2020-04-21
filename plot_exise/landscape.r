

mat = read.table(paste0(system.file("extdata", package = "ComplexHeatmap"), 
                        "/tcga_lung_adenocarcinoma_provisional_ras_raf_mek_jnk_signalling.txt"), 
                 header = TRUE,stringsAsFactors=FALSE, sep = "\t")
mat[is.na(mat)] = ""
mat <- mat[1:50,1:28]
rownames(mat) = mat[, 1]
mat = mat[, -1]
mat=  mat[, -ncol(mat)]
mat = t(as.matrix(mat))
###设置参数
col = c("MUT" = "#008000", "INDEL" = "red", "nonstop" = "blue","nonsense"= "yellow", "AMP"="orange", "HOMDEL"="gray")

alter_fun = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "#CCCCCC", col = NA))
  },
  INDEL = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = col["INDEL"], col = NA))
  },
  nonstop = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = col["nonstop"], col = NA))
  },
  MUT = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = col["MUT"], col = NA))
  },
  nonsense = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"),  h-unit(0.5, "mm"), gp = gpar(fill = col["nonsense"], col = NA))
  },
  AMP = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"),  h-unit(0.5, "mm"), gp = gpar(fill = col["AMP"], col = NA))
  },
  HOMDEL = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"),  h-unit(0.5, "mm"), gp = gpar(fill = col["HOMDEL"], col = NA))
  }
)

oncoPrint(mat, get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun = alter_fun, col = col, 
          remove_empty_columns = TRUE,show_pct = TRUE, pct_gp = gpar(fontsize = 8),row_names_gp = gpar(fontsize = 8),
          column_title = "OncoPrint for TCGA Lung Adenocarcinoma
          genes in Ras Raf MEK JNK signalling",
          heatmap_legend_param = list(title = "Alternations", at = c("INDEL", "nonstop", "MUT","nonsense","AMP","HOMDEL"), labels = c("INDEL", "nonstop", "Mutation","nonsense","AMP","HOMDEL")))