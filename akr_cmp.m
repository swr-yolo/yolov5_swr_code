path_all='D:\Ruler\swr_detect\dlproject\yolov5-pfy\swr_data\labels';%所有人工标注框坐标文件的路径
path_d = 'dlabels\';                   % 所有检测框坐标的文件路径
path_img='D:\Ruler\swr_detect\dlproject\yolov5-pfy\swr_data\images';%所有原始图片的路径

File_d = dir(fullfile(path_d,'*.txt'));  % 显示文件夹下所有符合后缀名为.txt文件的完整信息
FileNames_d = {File_d.name}';            % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列

d_idx=zeros(1,length(FileNames_d));
for i=1:length(FileNames_d)
    str=FileNames_d{i};
    d_idx(i)=str2num(str(1:4));
    
end


load test_idx.txt
%概述：
%先根据test的图片序号文件找到所有人工标注的test文件，读取其中信息标注在图上。再对yolo检测结果将坐标标注在图上。

for i=1:length(test_idx)
    L_idx=test_idx(i);
    img=imread([path_img,'\',num2str(L_idx),'.jpg']);

    
    akrs1=load([path_all,'\',num2str(L_idx),'.txt']);% 读取并画出手工标注的框
    if ~isempty(find(akrs1>0))%如果有框
        for j=1:size(akrs1,1)
            img=put_akr(img,akrs1(j,2:end),255);%白色是手工
        end
    end
    
    if ~isempty(find(d_idx==L_idx))%判断手工标注的图，
        akrs2=load([path_d,num2str(L_idx),'.txt']);%
        if ~isempty(find(akrs2>0))
            for j=1:size(akrs2,1)
                img=put_akr(img,akrs2(j,2:end),0);%黑色是识别
            end
            
            
        end
     
    end
        
     imwrite(img,['cmp_imgs\',num2str(L_idx),'.jpg']);

    i
end






function img_akr=put_akr(img,crd,type)
%假设yolo的5个数据分别为：label, x_, y_, w_, h_，
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







