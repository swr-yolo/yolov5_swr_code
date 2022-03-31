%挑选并制作用于yolov5识别用的拍摄钢丝绳图像数据集
%总图像5000张，3000train,1000val,1000test。
%断丝1040张，磨损1050张，普通1000张，一共3090张
%鉴于单个文件夹中的图像非常相似（仅有钢丝绳的微弱转动），train,val,test必须采用不同的文件夹
clear all
clc

%对断丝和磨损提取图片
totalnum=1;
picpf=30;%每个文件夹中挑选的图片数量
Nfb=52;
Nfw=35;

broken_idx=zeros(Nfb,picpf);%储存每个文件夹中随机选取的图像的序号
wear_idx=zeros(Nfw,picpf);
% load broken_idx
% load wear_idx


for foldernum=1:Nfw
    directory=strcat('wear\',num2str(foldernum));
    dirs=dir(directory);%dirs结构体类型,不仅包括文件名，还包含文件其他信息。
    dircell=struct2cell(dirs)'; %类型转化，转化为元组类型
    filenames=dircell(:,1) ;%文件名存放在第一列
    isdir=cell2mat(dircell(:,5));
    %然后根据后缀名筛选出指定类型文件并读入
    idx=find(isdir==0);
    filenames=filenames(idx);%获得大小
    N=length(filenames);
    numimg=randperm(N,picpf);
    wear_idx(foldernum,:)=numimg;%储存随机序号
    
    for i=1:picpf
        file=fullfile(directory,filenames{numimg(i)});
        img=imread(file);
        imwrite(img,['dataset-yolov5/all_wear/',num2str(totalnum),'.jpg'])
        totalnum=totalnum+1;
    end
    
    foldernum
    
end

%%
%提取正常钢丝绳图片
%正常图片提取1000张
totalnum=1;

directory=strcat('normal\');
dirs=dir(directory);%dirs结构体类型,不仅包括文件名，还包含文件其他信息。
dircell=struct2cell(dirs)'; %类型转化，转化为元组类型
filenames=dircell(:,1) ;%文件名存放在第一列
isdir=cell2mat(dircell(:,5));
%然后根据后缀名筛选出指定类型文件并读入
idx=find(isdir==0);
filenames=filenames(idx);%获得大小
N=length(filenames);
numimg=randperm(N,1000);
nm_idx=numimg;%储存随机序号

for i=1:1000
    file=fullfile(directory,filenames{numimg(i)});
    img=imread(file);
    imwrite(img,['dataset-yolov5/all_normal/',num2str(totalnum),'.jpg'])
    totalnum=totalnum+1;
    i
end


% save('nm_idx.mat','nm_idx')

%%
%
rand('seed',10)
rd_bk=randperm(1040);
rd_wr=randperm(1050);
rd_nm=randperm(1000);
idx=randperm(3090);

% train=1:3090*0.6;
% val=3090*0.6+1:3090*0.8;
% test=3090*0.8+1:3090;

for i= 1:3090
    
    p=idx(i);
    if p>2040
        p=p-2040;
        img=imread(['dataset-yolov5/all_wear/',num2str(p),'.jpg']);
        
    elseif p<=2040&&p>1000
        p=p-1000;
        img=imread(['dataset-yolov5/all_broken/',num2str(p),'.jpg']);
    else
        p=p;
        img=imread(['dataset-yolov5/all_normal/',num2str(p),'.jpg']);
    end
    
    imwrite(img,['H:\科研文件\钢丝检测\钢丝绳拍摄照片集\dataset-yolov5\images\',num2str(i),'.jpg'])
    
    i
end



%     directory=strcat('dataset-yolov5\broken');
%     dirs=dir(directory);%dirs结构体类型,不仅包括文件名，还包含文件其他信息。
%     dircell=struct2cell(dirs)'; %类型转化，转化为元组类型















