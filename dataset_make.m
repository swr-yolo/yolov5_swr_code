%��ѡ����������yolov5ʶ���õ������˿��ͼ�����ݼ�
%��ͼ��5000�ţ�3000train,1000val,1000test��
%��˿1040�ţ�ĥ��1050�ţ���ͨ1000�ţ�һ��3090��
%���ڵ����ļ����е�ͼ��ǳ����ƣ����и�˿����΢��ת������train,val,test������ò�ͬ���ļ���
clear all
clc

%�Զ�˿��ĥ����ȡͼƬ
totalnum=1;
picpf=30;%ÿ���ļ�������ѡ��ͼƬ����
Nfb=52;
Nfw=35;

broken_idx=zeros(Nfb,picpf);%����ÿ���ļ��������ѡȡ��ͼ������
wear_idx=zeros(Nfw,picpf);
% load broken_idx
% load wear_idx


for foldernum=1:Nfw
    directory=strcat('wear\',num2str(foldernum));
    dirs=dir(directory);%dirs�ṹ������,���������ļ������������ļ�������Ϣ��
    dircell=struct2cell(dirs)'; %����ת����ת��ΪԪ������
    filenames=dircell(:,1) ;%�ļ�������ڵ�һ��
    isdir=cell2mat(dircell(:,5));
    %Ȼ����ݺ�׺��ɸѡ��ָ�������ļ�������
    idx=find(isdir==0);
    filenames=filenames(idx);%��ô�С
    N=length(filenames);
    numimg=randperm(N,picpf);
    wear_idx(foldernum,:)=numimg;%����������
    
    for i=1:picpf
        file=fullfile(directory,filenames{numimg(i)});
        img=imread(file);
        imwrite(img,['dataset-yolov5/all_wear/',num2str(totalnum),'.jpg'])
        totalnum=totalnum+1;
    end
    
    foldernum
    
end

%%
%��ȡ������˿��ͼƬ
%����ͼƬ��ȡ1000��
totalnum=1;

directory=strcat('normal\');
dirs=dir(directory);%dirs�ṹ������,���������ļ������������ļ�������Ϣ��
dircell=struct2cell(dirs)'; %����ת����ת��ΪԪ������
filenames=dircell(:,1) ;%�ļ�������ڵ�һ��
isdir=cell2mat(dircell(:,5));
%Ȼ����ݺ�׺��ɸѡ��ָ�������ļ�������
idx=find(isdir==0);
filenames=filenames(idx);%��ô�С
N=length(filenames);
numimg=randperm(N,1000);
nm_idx=numimg;%����������

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
    
    imwrite(img,['H:\�����ļ�\��˿���\��˿��������Ƭ��\dataset-yolov5\images\',num2str(i),'.jpg'])
    
    i
end



%     directory=strcat('dataset-yolov5\broken');
%     dirs=dir(directory);%dirs�ṹ������,���������ļ������������ļ�������Ϣ��
%     dircell=struct2cell(dirs)'; %����ת����ת��ΪԪ������















