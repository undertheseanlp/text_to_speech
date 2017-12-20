#!/usr/bin/python
#
# Copyright (C) 2017 truongdo <truongdo@vais.vn>
#
# Distributed under terms of the modified-BSD license.
#
import sys
import os

fname = sys.argv[1]
num_chunk = int(sys.argv[2])
out_folder = sys.argv[3]

all_data = open(fname).readlines()

chunk_size = len(all_data)/num_chunk

start=0
end = 0

for i in range(0,num_chunk):
    start = i*chunk_size
    if i == num_chunk -1:
        end = len(all_data)
    else:
        end = i*chunk_size + chunk_size
    open(os.path.join(out_folder,"chunk_"+str(i)),"w").write("".join(all_data[start:end]))
