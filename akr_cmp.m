path_all='D:\Ruler\swr_detect\dlproject\yolov5-pfy\swr_data\labels';%�����˹���ע�������ļ���·��
path_d = 'dlabels\';                   % ���м���������ļ�·��
path_img='D:\Ruler\swr_detect\dlproject\yolov5-pfy\swr_data\images';%����ԭʼͼƬ��·��

File_d = dir(fullfile(path_d,'*.txt'));  % ��ʾ�ļ��������з��Ϻ�׺��Ϊ.txt�ļ���������Ϣ
FileNames_d = {File_d.name}';            % ��ȡ���Ϻ�׺��Ϊ.txt�������ļ����ļ�����ת��Ϊn��1��

d_idx=zeros(1,length(FileNames_d));
for i=1:length(FileNames_d)
    str=FileNames_d{i};
    d_idx(i)=str2num(str(1:4));
    
end


load test_idx.txt
%������
%�ȸ���test��ͼƬ����ļ��ҵ������˹���ע��test�ļ�����ȡ������Ϣ��ע��ͼ�ϡ��ٶ�yolo������������ע��ͼ�ϡ�

for i=1:length(test_idx)
    L_idx=test_idx(i);
    img=imread([path_img,'\',num2str(L_idx),'.jpg']);

    
    akrs1=load([path_all,'\',num2str(L_idx),'.txt']);% ��ȡ�������ֹ���ע�Ŀ�
    if ~isempty(find(akrs1>0))%����п�
        for j=1:size(akrs1,1)
            img=put_akr(img,akrs1(j,2:end),255);%��ɫ���ֹ�
        end
    end
    
    if ~isempty(find(d_idx==L_idx))%�ж��ֹ���ע��ͼ��
        akrs2=load([path_d,num2str(L_idx),'.txt']);%
        if ~isempty(find(akrs2>0))
            for j=1:size(akrs2,1)
                img=put_akr(img,akrs2(j,2:end),0);%��ɫ��ʶ��
            end
            
            
        end
     
    end
        
     imwrite(img,['cmp_imgs\',num2str(L_idx),'.jpg']);

    i
end






function img_akr=put_akr(img,crd,type)
%����yolo��5�����ݷֱ�Ϊ��label, x_, y_, w_, h_��
[h,w]=size(img);
x_=crd(1);
y_=crd(2);
w_=crd(3);
h_=crd(4);

x1 = floor(w * x_ - 0.5 * w * w_);
x2 = floor(w * x_ + 0.5 * w * w_);
y1 = floor(h * y_ - 0.5 * h * h_);
y2 = floor(h * y_ + 0.5* h * h_);

a=[x1,x2,y1,y2];
a(find(a<1))=1;
a(find(a>200))=200;

x1=a(1);x2=a(2);y1=a(3);y2=a(4);


img_akr=img;
if type~=0
    img_akr([y1,y2],x1:x2)=type;
    img_akr(y1:y2,[x1,x2])=type;
else
    img_akr([y1,y2],x1:2:x2)=type;
    img_akr(y1:2:y2,[x1,x2])=type;
    
end




%rect=[x1,y1,abs(x1-x2),abs(y1-y2)];



end







