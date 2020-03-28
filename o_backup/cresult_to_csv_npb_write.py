import numpy as np
import pandas as pd

#---------------- Save Settings ------------------

# File name to save DataFrame into csv
#save_name = "mod8_ior_w"
save_name = "out_mod8p_npb"

# File name of the iostat/throughput result
out_file = "out_mod8p"
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

for i in [9,16,25,36,49,64]:
    for k in range(1,3):
        listname.append(str(i)+"t")

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

index = ['throughput', 'latency(x1M)']
p_speed = 0.0
p_latency = 0
header = ""
column_n = ""
data_df = pd.DataFrame(index=index)
linecount = 0

#throughput & latency
listname = []

for i in [9,16,25,36,49,64]:
    for j in range(1,3):
        listname.append(str(i)+"t")

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
                temp_df = pd.DataFrame({column_n:[round(p_speed/linecount,2),round(p_latency/linecount/1000000,2)]},index=index)
                data_df = pd.concat([data_df,temp_df],axis=1)
                p_speed = 0.0
                p_latency = 0
                linecount = 0
                header = line.split("iter")[0]
                column_n = tmpdumpt
    elif (line.find("data") != -1):
        linecount += 1
        p_speed += float(line.split()[5])
    elif (line.find("pagevec") != -1):
        p_latency += int(line.split(":")[1])

f.close()

temp_df = pd.DataFrame({column_n:[round(p_speed/linecount,2),round(p_latency/linecount/1000000,2)]},index=index)
data_df = pd.concat([data_df,temp_df],axis=1)

#-------------------------------- Throughput & Latency DONE ---------
#print(iostat_df)
#print(data_df)
r = pd.concat([iostat_df,data_df],axis=0,sort=False).to_csv("result/"+save_name+".csv", mode='w')
