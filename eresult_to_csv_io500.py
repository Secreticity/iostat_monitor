import numpy as np
import pandas as pd
import re

#---------------- Save Settings ------------------

# File name to save DataFrame into csv
save_name = "out_mod4mix_ior_w"
#save_name = "org_npb"

# File name of the iostat/throughput result
out_file = "out_mod4mix"
#-------------------------------------------------

index = ['throughputR', 'throughputW']
data_df = pd.DataFrame(index=index)
rvalue = 0.0
wvalue = 0.0
switch = 1

f = open(out_file+".txt", 'r')
lines = f.readlines()
for line in lines:

    if (line.find("DONE") != -1):
        break

    elif (line.find("Proc") != -1):
    
        itera = int(line.split(":")[3].split(",")[0])

        if ( itera == 1 and ( rvalue != 0 or wvalue != 0 )):
            # save
            if (switch == 1):
                switch = 2
                annot = 'r10w90'
            elif (switch == 2):
                switch = 3
                annot = 'r50w50'
            elif (switch ==3):
                switch = 1
                annot = 'r90w10'

            column_n = proc+'_'+bsize+'_'+annot
            temp_df = pd.DataFrame({column_n:[round(rvalue/3,2),round(wvalue/3,2)]},index=index)
            data_df = pd.concat([data_df,temp_df],axis=1)

        proc = line.split(":")[1].split(",")[0]
        bsize = line.split(":")[2].split(",")[0]

    elif (line.find("Read") != -1):
        if ( itera == 1 ):
            rvalue = float(line.split()[4].split("(")[1])
        else:
            rvalue += float(line.split()[4].split("(")[1])

    elif (line.find("Write") != -1):
        if ( itera == 1 ):
            wvalue = float(line.split()[4].split("(")[1])
        else:
            wvalue += float(line.split()[4].split("(")[1])

f.close()

column_n = proc+'_'+bsize+'_r90w10'
temp_df = pd.DataFrame({column_n:[round(rvalue/3,2),round(wvalue/3,2)]},index=index)
data_df = pd.concat([data_df,temp_df],axis=1)

r = data_df.to_csv("result/"+save_name+".csv", mode='w')
