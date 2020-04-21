#/sur/bin/python
#-*- coding:utf-8 -*-

import sys

anno_file = sys.argv[1]

name = sys.argv[2]    #需要绘图的样本名称
gene = sys.argv[3]    #需要绘图的基因名称

'''{'name2': [], 'name3': [], 'name1': []}
'''
dict_name = {}
list_name = []  #存放样本名称
with open(name,"r") as name_file:
    for n in name_file:
        n = n.strip()
        list_name.append(n)
        dict_name[n] = []


'''{'gene1': {'name2': [], 'name3': [], 'name1': []}, 'gene2': {'name2': [], 'name3': [], 'name1': []}, 'gene3': {'name2': [], 'name3': [], 'name1': []}}
'''
dict_all = {}
with  open(gene, "r") as gene_file:
    for g in gene_file:
        g = g.strip()
        dict_all[g] = dict_name


with open(anno_file, "r") as infile:
    header = infile.readline().strip()
    head = header.split("\t")
    GeneName = head.index("GeneName")
    ExonicFunc = head.index("ExonicFunc")
    FORMAT = head.index("FORMAT")
    Ori_REF = head.index("Ori_REF")
    for line in infile:
        line = line.strip()
        lline = line.split("\t")   #分割一行
        #print(lline)
        gene_n =  lline[GeneName]  #该行的基因名
        #print(gene_n)
        labels = lline[ExonicFunc]  #
        for n in range(FORMAT+1, Ori_REF ):
            #print(n)
            if lline[n] ==  ".":
                #print(head[n])
                dict_all[gene_n][head[n]].append("NA")
                print(dict_all.keys())
                 
            elif lline[n] != "." :
                dict_all[gene_n][head[n]].append(labels)
                #dict_all[gene_n][head[n]] = list(set(dict_all[gene_n][head[n]]))
            else:
                break
        #print(dict_all)
        #break

#print(dict_all)

#print(dict_all["RAD9A"])              
with open(sys.argv[4], "w") as outfile:
    for k,v in dict_all.items():
        outfile.write("%s\t" % k)
        for name in list_name:
            outfile.write("%s\t" % dict_all[k][name])
        outfile.write("\n")
        

#print(dict_all)
