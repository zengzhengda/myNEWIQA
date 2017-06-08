%��������Ҫ��RGBͼ�����,�������ַ���:
% ����1:�������ͼ��Ϊ��ɫͼ��, ���Ƚ��лҶȻ�����,���ջҶ�ͼ�����
% ����2:��RGBͼ������������з���֮�ͳ���ͼ��ߴ��ٳ���3
% ����ǰ������ͼ��ľ��������MSE����ֵ�����PSNR
function r=PSNR(X,Y);%

[r,cl]=size(X);   %����ͼ��ߴ�
c=cl/3;    % ��ɫͼ��   384*512�� 384  1536
mse_m=double(zeros(r,c));
choice=2;     %�ҶȻ�
if (choice==1) 
        X=rgb2gray(X);
        Y=rgb2gray(Y);
        X=double(X);     %double ���˰��� ����double���ܳ���X(i,j)=80��Y(i,j)=90��X(i,j)-Y(i,j)=0
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