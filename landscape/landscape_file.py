#/sur/bin/python
#-*- coding:utf-8 -*-

'''下一步优化，给出样本名参数和基因参数，无需自己先对文件进行处理
'''

import sys
from collections import defaultdict
from commands import getoutput

if len(sys.argv) < 3:
    print("Usage: python landscape.py anno_file.xls genelist outfile")
    exit()

anno_file = sys.argv[1]

gene = sys.argv[2]      #需要绘图的基因名称
    
'''anno_file文件需要自己先处理，只能包含指定样本，指定基因；
   可以使用集群工具annotools完成
'''

'''
{
    "gene":
    {   "name1":[],
        "name2":[],
        "name3":[]
    },

    "gene2":
    {   "name1":[],
        "name2":[],
        "name3":[]
    }
}
''' 

dict_all = defaultdict(dict)
with open(gene) as f1:
    for line in f1:
        gname = line.strip()
        dict_all[gname] = defaultdict(list)

with open(anno_file,"r") as infile:
    head = infile.readline()
    head = head.strip()
    header = head.split("\t")   
    GeneName = header.index("GeneName")   
    Label = header.index("ExonicFunc")     #突变标签的类型
    FORMAT = header.index("FORMAT")
    Ori_REF = header.index("Ori_REF")
    
    for line in infile:
        line = line.strip()
        lline = line.split("\t")
        gene_name = lline[GeneName]     
        labels = lline[Label]           #获得该行，该基因的标签
        for sam in range(FORMAT+1,Ori_REF):
            if lline[sam] =="."  or  lline[sam].startswith("0/0"): #适用于4.5和4.6
                dict_all[gene_name][header[sam]].append("NA")
            else:
                dict_all[gene_name][header[sam]].append(labels)

# print(dict_all)    
# print(dict_all.keys())
    
with open(sys.argv[3], "w") as outf:
    num = dict_all.keys()[1]
    #outf.write("%s\t%s\n" % ("gene","\t".join(dict_all[num].keys()))) #字典的顺序和输入文件的顺序有差别
    outf.write("\t%s\n" % ("\t".join(dict_all[num].keys())))  #去掉了第一列"gene"字符，便于R画图处理
    for k,v in dict_all.items():
        outf.write("%s" % k)
        for k,v in v.items():
            str = []
            for i in v:
                if i == "NA":
                    pass
                elif i in str:
                    pass
                else:
                    str.append(i)
            #print(str)
            outf.write("\t%s" % ",".join(str))
        outf.write("\n")

'''判断输出的结果文件中，字段是否正常，测试时，即使字段异常,画图也不会报错。
'''
len_n = getoutput("awk -F '\t' '{print NF}' %s | sort -u |wc -l" % sys.argv[3])
if len_n == "1":
    print("The result file is OK!")
else:
    print(len_n,"result file is wrong!")


#print(dict_all.keys())