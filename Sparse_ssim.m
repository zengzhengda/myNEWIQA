function[ssim_sparse] = Sparse_ssim(img1,img2,param)
% sparse parameters setting
paramRegression.mode = 2 ;
paramRegression.lambda = param.lambda(1) ;
paramRegression.lambda2 = param.lambda(2) ;
sizeWindow = 2*param.semiN + 1;    % size of window of samples
codeWeight = [1 2 2^2 2^3 2^4 2^5 2^6 2^7] ; % coding weight

% ssim parameters setting
K(1)=0.01;
K(2)=0.03;
L=255;
C1=(K(1)*L)^2;
C2=(K(2)*L)^2;

img1=double(img1);
img2=double(img2);
imp1 = padarray(img1, [param.semiN + 1, param.semiN + 1], param.padval) ;  % image padding
imp2 = padarray(img2, [param.semiN + 1, param.semiN + 1], param.padval) ;  % image padding

% variables initializing
[r,c]=size(img1);
Y1 = zeros(8*(param.semiN + 1), 1) ;    % temple variable to obtain regression coefficients
X1 = zeros((2*param.semiN + 1)^2, 8) ;    % temple variable to obtain regression coefficients
Y2 = zeros(8*(param.semiN + 1), 1) ; 
X2 = zeros((2*param.semiN + 1)^2, 8) ; 
ssim_map=zeros(r,c); % ssim map initializing
% feature extraction
for i = 1 : r
    for j = 1 : c              %pixel iteration
        numSample = 0 ;  % counter of samples in a  block
        R = i + param.semiN + 1 ;  % row coordinate in padded image
        C = j + param.semiN + 1 ;  % column coordinate in padded image
        beginR = R - param.semiN - 1 ; % beginning index in padded image 
        beginC = C - param.semiN - 1 ;  % beginning index in padded image
        for m = 1 : sizeWindow
            for n = 1 : sizeWindow   % sample iteration
                numSample = numSample + 1 ;
                Y1(numSample, 1) = imp1(beginR + m, beginC + n) ;
                Y1(numSample, 1) =Y1(numSample, 1)/ norm(Y1(numSample, 1)) ;
                X1(numSample, :) = [imp1(beginR + m - 1, beginC + n - 1), imp1(beginR + m - 1, beginC + n), imp1(beginR + m - 1, beginC + n + 1), ...
                 imp1(beginR + m, beginC + n - 1), imp1(beginR + m, beginC + n + 1), imp1(beginR + m + 1, beginC + n - 1), ...
                    imp1(beginR + m + 1, beginC + n), imp1(beginR + m + 1, beginC + n + 1)]' ;
                X1(numSample, :) =X1(numSample, :)/ norm(X1(numSample, :)) ;

                Y2(numSample, 1) = imp2(beginR + m, beginC + n) ;
                Y2(numSample, 1) =Y2(numSample, 1)/ norm(Y2(numSample, 1)) ;
                X2(numSample, :) = [imp2(beginR + m - 1, beginC + n - 1), imp2(beginR + m - 1, beginC + n), imp2(beginR + m - 1,beginC + n + 1), ...
                imp2(beginR + m, beginC + n - 1), imp2(beginR + m, beginC + n + 1), imp2(beginR + m + 1, beginC + n - 1), ...
                    imp2(beginR + m + 1, beginC + n), imp2(beginR + m + 1, beginC + n + 1)]' ;
                X2(numSample, :) =X2(numSample, :)/ norm(X2(numSample, :)) ;
            end
        end
        
        %compute the local mean,standard deviation, and covariance
        [tempCoes1 path1] = mexLasso(Y1, X1, paramRegression) ;
        tempCoes1 = full(tempCoes1)' ;
        tempCoes1=[tempCoes1(1:4) 1 tempCoes1(5:8)];
        tempCoes1=reshape(tempCoes1,[3,3]);
        patch1=imp1(R-1:R+1,C-1:C+1);
        patch11=tempCoes1.*patch1;
        mu1=mean2(patch11);
        sigma1=std(patch11(:),1);
        
        [tempCoes2 path2] = mexLasso(Y2, X2, paramRegression) ;
        tempCoes2 = full(tempCoes2)' ;
        tempCoes2=[tempCoes2(1:4) 1 tempCoes2(5:8)];
        tempCoes2=reshape(tempCoes2,[3,3]);
        patch2=imp2(R-1:R+1,C-1:C+1);
        patch22= tempCoes2 .* patch2;
        mu2=mean2(patch22);
        sigma2=std(patch22(:),1);
        
        sigma12=mean2(patch11 .* patch22) - mu1 *mu2;
        
        ssim_local=(2*mu1*mu2+C1)*(2*sigma12+C2)./((mu1^2+mu2^2+C1)*(sigma1^2+sigma2^2+C2));
        ssim_map(i,j)=ssim_local;
    end
end
ssim_sparse=mean2(ssim_map(~isnan(ssim_map)));

% ssim_sparse=mean2(ssim_map);