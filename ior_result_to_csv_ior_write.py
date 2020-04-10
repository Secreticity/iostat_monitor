import numpy as np
import pandas as pd

#---------------- Save Settings ------------------

# File name to save DataFrame into csv
save_name = "out_org_onlyior_ior_w"
#save_name = "org_npb"

# File name of the iostat/throughput result
out_file = "out_org_onlyior"
#-------------------------------------------------

index = ['throughput']
p_speed = 0.0
header = ""
column_n = ""
data_df = pd.DataFrame(index=index)
linecount = 0

#throughput
listname = []


for i in [8,16,32,64,128,256]:

    size_order=['64m','128m','256m','512m','1024m']
    for j in size_order:
        for k in range(1,4):
            listname.append(str(i)+"t_"+str(j))

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
                temp_df = pd.DataFrame({column_n:[round(p_speed/3,2)]},index=index)
                data_df = pd.concat([data_df,temp_df],axis=1)
                p_speed = 0.0
                linecount = 0
                header = line.split("iter")[0]
                column_n = tmpdumpt
    elif (line.find("Max") != -1):
        linecount += 1
        p_speed += float(line.split()[2])

f.close()

temp_df = pd.DataFrame({column_n:[round(p_speed/3,2)]},index=index)
data_df = pd.concat([data_df,temp_df],axis=1)

#-------------------------------- Throughput & Latency DONE ---------
r = data_df.to_csv("result/"+save_name+".csv", mode='w')
