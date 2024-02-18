clc 
clear all
chromo=fileread("chromo_manipulated.txt");
n=1;i=1;
%file manipulation
for j=1:4096
    if chromo(1,j)>64
        chromo(1,j)=chromo(1,j)-55;
    else if chromo(1,j)>47 && chromo(1,j)<58
            chromo(1,j)=chromo(1,j)-48;
    end
    end
        if j==(64+n)
            n=64+n;
            i=i+1;
            chromosomes(i,j-(n-1))=chromo(1,j);  
        else
            chromosomes(i,j-(n-1))=chromo(1,j);
        end
end
%% display task 1
%original image
chromosomes=double(chromosomes);
figure(1)
colormap(gray)
image(chromosomes,"CDataMapping","scaled")

%% binarizing task 2
%binary image
H=zeros(1,32);
binaryImage=zeros(64,64);
for i=1:64
    for j=1:64
        if chromosomes(i,j)<21
            binaryImage(i,j)=0;
        else
            binaryImage(i,j)=1;
        end
        H(chromosomes(i,j)+1)=H(chromosomes(i,j)+1)+1;
    end
end
pad_binary=ones(66,66);
pad_binary(2:65,2:65)=binaryImage;
for i=2:65
    for j=2:65
         if (pad_binary(i,j)==1)&&((pad_binary(i+1,j+1)==0 & pad_binary(i-1,j-1)==0) || (pad_binary(i-1,j+1)==0 & pad_binary(i+1,j-1)==0)|| (pad_binary(i,j+1)==0 & pad_binary(i,j-1)==0)|| (pad_binary(i-1,j)==0 & pad_binary(i+1,j)==0))
            pad_binary(i,j)=0;
        else
            continue
         end
    end
end
figure(2)
binaryImage=pad_binary(2:65,2:65);
colormap(gray)
image(binaryImage,"CDataMapping","scaled")

%% thinning task 3
%%zhang-suen thin image
count=1;
[r, c]=size(binaryImage);
thinImage=1-binaryImage;
delete=ones(r, c);
while count
    count=0;
    for i=2:r-1
        for j=2:c-1
            P=[thinImage(i,j) thinImage(i-1,j) thinImage(i-1,j+1) thinImage(i,j+1) thinImage(i+1,j+1) thinImage(i+1,j) thinImage(i+1,j-1) thinImage(i,j-1) thinImage(i-1,j-1) thinImage(i-1,j)]; % P1, P2, P3, ... , P8, P9, P2
            if (thinImage(i,j)==1 &&  sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(6)==0 && P(4)*P(6)*P(8)==0)   % conditions
                A=0;
                for k=2:size(P,2)-1
                    if P(k)==0 && P(k+1)==1
                        A=A+1;
                    end
                end
                if (A==1)
                    delete(i,j)=0;
                    count=1;
                end
            end
        end
    end
    thinImage=thinImage.*delete;  
    for i=2:r-1
        for j=2:c-1
            P=[thinImage(i,j) thinImage(i-1,j) thinImage(i-1,j+1) thinImage(i,j+1) thinImage(i+1,j+1) thinImage(i+1,j) thinImage(i+1,j-1) thinImage(i,j-1) thinImage(i-1,j-1) thinImage(i-1,j)];
            if (thinImage(i,j)==1 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2 && P(2)*P(4)*P(8)==0 && P(2)*P(6)*P(8)==0)   % conditions
                A=0;
                for k=2:size(P,2)-1
                    if P(k)==0 && P(k+1)==1
                        A=A+1;
                    end
                end
                if (A==1)
                    delete(i,j)=0;
                    count=1;
                end
            end
        end
    end
    thinImage=thinImage.*delete;
end
figure(3)
colormap(gray(2))
image(thinImage,"CDataMapping","scaled")

%% outline task 4
%outlined image
for i=2:65
    for j=2:65
        if abs(pad_binary(i,j)-pad_binary(i,j-1))==1 || abs(pad_binary(i,j)-pad_binary(i-1,j))==1
            outlineChromo(i,j)=1;
        else
            outlineChromo(i,j)=0;
        end
    end
end
figure(4)
outlineChromo=outlineChromo(2:65,2:65);
colormap(gray)
image(outlineChromo,"CDataMapping","scaled")

%% labelling task 5
%labelling
pad_binary=1-pad_binary;
tag=1;
for i=2:65
    for j=2:65
        if pad_binary(i,j)==1
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j-1)];
             if pad_binary(i-1,j-1)==0 & pad_binary(i-1,j)==0 & pad_binary(i-1,j+1)==0 & pad_binary(i,j-1)==0
                 pad_binary(i,j)=tag;
                 tag=tag+1;
             elseif nnz(nbs)==1
                 index=find(nbs);
                 pad_binary(i,j)=nbs(index);
             else
                 indices=find(nbs);
                 l=min(nbs(indices));
                 pad_binary(i,j)=l;
             end
        end
    end
end
for i=2:65
    for j=2:65
        if pad_binary(i,j)~=0
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j+1) pad_binary(i,j) pad_binary(i,j-1) pad_binary(i+1,j+1) pad_binary(i+1,j) pad_binary(i+1,j-1)];
                if nnz(nbs)>=0      
                indices=find(nbs);
                  l=max(nbs(indices));
                 pad_binary(i,j)=l;
                end
        end
    end
end
for i=65:-1:2
    for j=65:-1:2
        if pad_binary(i,j)~=0
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j+1) pad_binary(i,j) pad_binary(i,j-1) pad_binary(i+1,j+1) pad_binary(i+1,j) pad_binary(i+1,j-1)];
                if nnz(nbs)>=0      
                indices=find(nbs);
                  l=max(nbs(indices));
                 pad_binary(i,j)=l;
                end
        end
    end
end
for i=2:65
    for j=65:-1:2
        if pad_binary(i,j)~=0
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j+1) pad_binary(i,j) pad_binary(i,j-1) pad_binary(i+1,j+1) pad_binary(i+1,j) pad_binary(i+1,j-1)];
             if nnz(nbs)>=0      
             indices=find(nbs);
                  l=max(nbs(indices));
                 pad_binary(i,j)=l;
             end
        end
    end
end
for i=65:-1:2
    for j=2:65
        if pad_binary(i,j)~=0
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j+1) pad_binary(i,j) pad_binary(i,j-1) pad_binary(i+1,j+1) pad_binary(i+1,j) pad_binary(i+1,j-1)];
                if nnz(nbs)>=0      
                indices=find(nbs);
                  l=max(nbs(indices));
                 pad_binary(i,j)=l;
                end
        end
    end
end
for i=2:65
    for j=2:65
        if pad_binary(i,j)~=0
             nbs=[pad_binary(i-1,j-1) pad_binary(i-1,j) pad_binary(i-1,j+1) pad_binary(i,j+1) pad_binary(i,j) pad_binary(i,j-1) pad_binary(i+1,j+1) pad_binary(i+1,j) pad_binary(i+1,j-1)];
                if nnz(nbs)>=0      
                indices=find(nbs);
                  l=max(nbs(indices));
                 pad_binary(i,j)=l;
                end
        end
    end
end
labelledImage=pad_binary(2:65,2:65);
%remove unwanted objects
for i=1:64
    for j=1:64
        if labelledImage(i,j)==1 || labelledImage(i,j)==4 || labelledImage(i,j)==13
            labelledImage(i,j)=0;
        end
    end
end
figure(5)
image(labelledImage,"CDataMapping","scaled")

%% rotation task 6
%rotate an image 
theta=-90;
d=sqrt(64^2+64^2);
r=round(d-64)+1;
R=r+64;
c=round(d-64)+1;
C=c+64;
padImage=zeros(R,C);
padImage(r/2:r/2+63,c/2:c/2+63)=chromosomes;
xc=round((c+65)/2);
yc=round((r+65)/2);
for i=1:R
    for j=1:C
         x=(i-xc)*cosd(theta)+(j-yc)*sind(theta);
         y=-(i-xc)*sind(theta)+(j-yc)*cosd(theta);
         x=round(x)+xc;
         y=round(y)+yc;
         if (x>=1&x<=R && y>=1&y<=C)
              rotatedImage(i,j)=padImage(x,y);          
         end
    end
end
figure(6)
colormap("gray")
image(rotatedImage,"CDataMapping","scaled")

%% extra code tryouts
% %histogram equalization
% Hc=zeros(size(H));
% Hc(1)=H(1);
% for i=2:32
%         Hc(i)=Hc(i-1)+H(i);
% end
% T=round(31*Hc/(64*64));
% histEq=zeros(size(chromosomes));
% for i=1:64
%     for j=1:64
%         histEq(i,j)=T(chromosomes(i,j)+1);
%     end
% end
% figure(3)
% colormap(gray)
% image(histEq)

%smoothing did not work
%smooth=zeros(66,66)
% for i=2:65
%     for j=2:65
%         c=0;
%         for k=i-1:i+1
%             for l=j-1:j+1
%                 c=c+smooth(k,l);
%             end
%         end
%         smooth(i,j)=c/9;
%     end
% end
% figure(3)
% colormap(gray)
% image(smooth,"CDataMapping","scaled")
