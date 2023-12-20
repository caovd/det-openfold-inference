'''
Read txt logs file from nvidia-smi, ex., 
nvidia-smi dmon -i 0 -s mu -d 1 -o TD -f gpu_logs_5005.txt
'''

import glob
import pandas as pd
import numpy as np 
import matplotlib.pyplot as plt 

directory = '/PATH/TO/openfold/outputs/logs/gpu_util'
for filename in glob.glob(directory + '/*.txt'):
    with open(filename) as f:
        line_filtered = []
        gpu_mem = []
        for line in f:
            if "#Date" not in line and "#YYYYMMDD" not in line: 
                line_filtered.append(line)
                gpu_mem.append(int(line.split()[3]))
        
        plt.xlabel("Time [min]") 
        plt.ylabel("GPU VRAM") 
        if "5005" in filename:
            plt.plot(np.arange(len(gpu_mem))/60, gpu_mem, color ="r") 
            plt.title(f"{filename.split('/')[-1].split('.')[0]} - peak @ {max(gpu_mem)} MB --> OOM")
        else:
            plt.plot(np.arange(len(gpu_mem))/60, gpu_mem, color ="b") 
            plt.title(f"{filename.split('/')[-1].split('.')[0]} - peak @ {max(gpu_mem)} MB")
        plt.xlim(0, 210)
        plt.ylim(0, 80000)
        plt.show()