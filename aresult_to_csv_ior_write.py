import numpy as np
import pandas as pd

#---------------- Save Settings ------------------

# File name to save DataFrame into csv
save_name = "out_mod16v_ior_w"
#save_name = "org_npb"

# File name of the iostat/throughput result
out_file = "out_mod16v"
#-------------------------------------------------

state = "INIT"
listname = []
header = ""
#usr / nice / system / iowait / steal / idle
index = ['usr','nice','system','iowait','steal','idle']
p_usr = 0.00
p_nice = 0.00
p_system = 0.00
p_iowait = 0.00
p_steal = 0.00
p_idle = 0.00
linecount = 0

iostat_df = pd.DataFrame(index=index)

for i in [8,16,32,64,128,256]:
    if i==8:
        size_order=['512m','1g','2g','4g']
    elif i==16:
        size_order=['256m','512m','1g','2g']
    elif i==32:
        size_order=['128m','256m','512m','1g']
    elif i==64:
        size_order=['64m','128m','256m','512m']
    elif i==128:
        size_order=['32m','64m','128m','256m']
    elif i==256:
        size_order=['16m','32m','64m','128m']

    for j in size_order:
        for k in range(1,4):
            listname.append(str(i)+"t_"+str(j))

f = open(out_file+"_iostat.txt", 'r')
lines = f.readlines()
for line in lines:
    if(state == "INIT" or state == "END"):
        if(line.find("start---") != -1):
            state = "START"
            if (header == ""):
                header = listname.pop(0)
            else:
                comphead = listname.pop(0)
                if (header != comphead):
                    temp_df = pd.DataFrame({header:[round(p_usr/linecount,2),round(p_nice/linecount,2),round(p_system/linecount,2),round(p_iowait/linecount,2),round(p_steal/linecount,2),round(p_idle/linecount,2)]},index=index)
                    iostat_df = pd.concat([iostat_df,temp_df],axis=1)
                    p_usr = 0.00
                    p_nice = 0.00
                    p_system = 0.00
                    p_iowait = 0.00
                    p_steal = 0.00
                    p_idle = 0.00
                    header = comphead
                    linecount = 0

    elif (state == "START"):
        if(line.find("end---") != -1):
            state = "END"
        else:
            p_usr += float(line.split()[1])
            p_nice += float(line.split()[2])
            p_system += float(line.split()[3])
            p_iowait += float(line.split()[4])
            p_steal += float(line.split()[5])
            p_idle += float(line.split()[6])
            linecount += 1
    else:
        print("exception error")
f.close()

temp_df = pd.DataFrame({header:[round(p_usr/linecount,2),round(p_nice/linecount,2),round(p_system/linecount,2),round(p_iowait/linecount,2),round(p_steal/linecount,2),round(p_idle/linecount,2)]},index=index)
iostat_df = pd.concat([iostat_df,temp_df],axis=1)

#-------------------------------- iostat reader DONE ----------

index = ['throughput', 'latency(x1M)', 'm_count']
p_speed = 0.0
p_latency = 0
p_count = 0
header = ""
column_n = ""
data_df = pd.DataFrame(index=index)
linecount = 0

#throughput & latency
listname = []


for i in [8,16,32,64,128,256]:
    if i==8:
        size_order=['512m','1g','2g','4g']
    elif i==16:
        size_order=['256m','512m','1g','2g']
    elif i==32:
        size_order=['128m','256m','512m','1g']
    elif i==64:
        size_order=['64m','128m','256m','512m']
    elif i==128:
        size_order=['32m','64m','128m','256m']
    elif i==256:
        size_order=['16m','32m','64m','128m']

    for j in size_order:
        for k in range(1,4):
            listname.append(str(i)+"t_"+str(j))
"""
for i in [9,16,36,64]:
    for j in range(1,3):
        listname.append(str(i)+"t")
"""

f = open(out_file+".txt", 'r')
lines = f.readlines()
for line in lines:
    if (line.find("Proc") != -1):
        if (header == ""):
            column_n = listname.pop(0)
            header = line.split("iter")[0]
        else:
            tmpdumpt = listname.pop(0)
            if (header != line.split("iter")[0]):
                temp_df = pd.DataFrame({column_n:[round(p_speed/3,2),round(p_latency/3000000,2),round(p_count/3,2)]},index=index)
                data_df = pd.concat([data_df,temp_df],axis=1)
                p_speed = 0.0
                p_latency = 0
                p_count = 0
                linecount = 0
                header = line.split("iter")[0]
                column_n = tmpdumpt
    elif (line.find("Max") != -1):
        linecount += 1
        p_speed += float(line.split()[2])
    elif (line.find("data") != -1):
        linecount += 1
        p_speed += float(line.split()[5])
    elif (line.find("pagevec") != -1):
        p_latency += int(line.split(":")[1].split()[0])
        p_count += int(line.split(":")[1].split()[1])

f.close()

temp_df = pd.DataFrame({column_n:[round(p_speed/3,2),round(p_latency/3000000,2),round(p_count/3,2)]},index=index)
data_df = pd.concat([data_df,temp_df],axis=1)

#-------------------------------- Throughput & Latency DONE ---------
r = pd.concat([iostat_df,data_df],axis=0,sort=False).to_csv("result/"+save_name+".csv", mode='w')
