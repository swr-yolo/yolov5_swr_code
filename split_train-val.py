# coding:utf-8

import os
import random
import argparse
import numpy as np
import math
import string

def chouyang(a,n):
    p=True
    vgrp=np.zeros((math.floor(len(a)/n),n))
    ct=0
    while p:
        b=random.sample(a,n)
        b.sort()   #排序
        a=list(set(a).difference(set(b)))  #去除已抽样的数据
        if len(a)>0:
            p=True
            vgrp[ct, :] = b
            ct=ct+1
        else:
            p=False
    return vgrp


parser = argparse.ArgumentParser()
# xml文件的地址，根据自己的数据进行修改 xml一般存放在Annotations下
parser.add_argument('--xml_path', default='Annotations', type=str, help='input xml label path')
# 数据集的划分，地址选择自己数据下的ImageSets/Main
parser.add_argument('--txt_path', default='ImageSets/Main', type=str, help='output txt label path')
opt = parser.parse_args()

train_percent = 0.8
xmlfilepath = opt.xml_path
txtsavepath = opt.txt_path
total_xml = os.listdir(xmlfilepath)
if not os.path.exists(txtsavepath):
    os.makedirs(txtsavepath)

num = len(total_xml)
# list_index = range(num)
# trainval = random.sample(list_index, tv)
# train = random.sample(trainval, tr)
list_index = np.zeros((num, 1))

for i in range(num):
    name = os.path.splitext(total_xml[i])[0]
    list_index[i] = int(name)


# 得到训练集和验证集对应的编号
trainval = list_index[np.logical_or(list_index <= 1000, list_index >= 3001)]

num_tv = len(trainval)
num_v=math.floor(num_tv*( 1-train_percent))
num_t=num_tv-num_v


v_set=chouyang(trainval,num_v)

# t_set = np.zeros((5, num_t))
# v_set = np.zeros((5, num_v))
#
# # python “：“后面的索引会被去掉
# for i in range(5):
#     v_set[i, :] = trainval[i*num_v:(i+1)*num_v]
#     t_idx=np.logical_or(np.arange(num_tv)<i*num_v, np.arange(num_tv)>(i+1)*num_v-1)
#     t_set[i, :] =trainval[t_idx]




file_trainval = open(txtsavepath + '/trainval.txt', 'w')
file_test = open(txtsavepath + '/test.txt', 'w')
file_train = open(txtsavepath + '/train.txt', 'w')
file_val = open(txtsavepath + '/val.txt', 'w')




for i in range(num):
    name = total_xml[i][:-4] + '\n'
    k = list_index[i]
    if np.any(trainval == k):
        file_trainval.write(name)
        if np.any(v_set[0, :] == k):
            file_val.write(name)
        else:
            file_train.write(name)
    else:
        file_test.write(name)


file_trainval.close()
file_train.close()
file_val.close()
file_test.close()
