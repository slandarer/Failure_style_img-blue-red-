function BlueRed
bkgPic=imread('test6.jpg');%pic path(图片地址)
lineDensity=0.6;           %Probability of occurrence of fault line(故障线条出现概率)
lineLenRange=[50,80];      %Fault line length range(故障线条长度范围)
greenMoveLen=10;           %Green move distance(绿移距离)



[m,n,k]=size(bkgPic);
if k~=1
    bkgPic=rgb2gray(bkgPic);
end

matSize=[n,m];
vector=[1,0];
colorList=[21    27   143
    68    22   113
    94    72   151
   175   152   192
   221   188   204
   217   156   174
   203    82   104
   232    31    37
   151     5    11];

colorMat=vColorMat(matSize,vector,colorList);
blueRedPic=uint8(double(colorMat).*double(bkgPic)./200);


Rchannel=blueRedPic(:,1+greenMoveLen:end,1);
Gchannel=blueRedPic(:,1:end-greenMoveLen,2);
Bchannel=blueRedPic(:,1+greenMoveLen:end,3);
gm_brPic(:,:,1)=Rchannel;
gm_brPic(:,:,2)=Gchannel;
gm_brPic(:,:,3)=Bchannel;


tempRand=rand(1,m);
[~,movePos]=sort(tempRand);
movePos=movePos(1:floor(m*lineDensity));
movePos=sort(movePos);

movePic=gm_brPic(movePos,:,1);

for i=1:size(movePic,1) 
    H = fspecial('motion',randi(lineLenRange,[1,1]),0);
    movePic(i,:) = imfilter(movePic(i,:),H,'replicate');
end


gm_brPic(movePos,:,1)=movePic;
imshow(gm_brPic);
end