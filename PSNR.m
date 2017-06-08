%本程序主要对RGB图像计算,采用两种方法:
% 方法1:如果读入图像为彩色图象, 首先进行灰度化处理,依照灰度图象计算
% 方法2:对RGB图像均方差是所有方差之和除以图像尺寸再除以3
% 计算前后两副图像的均方根误差MSE、峰值信噪比PSNR
function r=PSNR(X,Y);%

[r,cl]=size(X);   %读入图像尺寸
c=cl/3;    % 彩色图像   384*512： 384  1536
mse_m=double(zeros(r,c));
choice=2;     %灰度化
if (choice==1) 
        X=rgb2gray(X);
        Y=rgb2gray(Y);
        X=double(X);     %double 坑人啊， 不加double可能出现X(i,j)=80，Y(i,j)=90，X(i,j)-Y(i,j)=0
        Y=double(Y);
        if any(size(X)~=size(Y))
            error('The input size is not equal to each other!');
        end
        
        for i=1:r
            for j=1:c
                mse_m(i,j)=(X(i,j)-Y(i,j))^2;
            end
        end
        mse=sum(mse_m(:))/(r*c);

else if(choice==2)
    
        if any(size(X)~=size(Y))
            error('The input size is not equal to each other!');
        end
        Xr=double(X(:,:,1));
        Xg=double(X(:,:,2));
        Xb=double(X(:,:,3));
        Yr=double(Y(:,:,1));
        Yg=double(Y(:,:,2));
        Yb=double(Y(:,:,3));
        
        for i=1:r
            for j=1:c
                mse_mR(i,j)=(Xr(i,j)-Yr(i,j))^2;
                mse_mG(i,j)=(Xg(i,j)-Yg(i,j))^2;
                mse_mB(i,j)=(Xb(i,j)-Yb(i,j))^2;
            end
        end
        %mse=sum(mse_m(:))/(r*c);
        mseRGB=sum(mse_mR(:))+sum(mse_mG(:))+sum(mse_mB(:));
        mse=mseRGB/(r*c*3);
    end
    
end

% PSNR = 10*log10(255^2/MSE);
r=10*log(double(255*255/mse))/log(10);