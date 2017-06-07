function sx = gausssmooth(IM,sigma)
%GAUSSGRADIENT Gradient using first order derivative of Gaussian.
%  sx = gausssmooth(IM,sigma) outputs the smooth version of
%  image IM using a 2-D Gaussian kernel. Sigma is the standard deviation of
%  this kernel along both directions.
%
%  Contributed by WangBiao (wangbiao08@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

%determine the appropriate size of kernel. The smaller epsilon, the larger
%size.
epsilon=1e-2;
halfsize=ceil(sigma*sqrt(-2*log(sqrt(2*pi)*sigma*epsilon)));
size=2*halfsize+1;
%generate a 2-D Gaussian kernel along x direction
for i=1:size
    for j=1:size
        u=[i-halfsize-1 j-halfsize-1];
        h(i,j)=gauss(u(1),sigma)* gauss(u(2),sigma);
    end
end
h=h/sqrt(sum(sum(abs(h).*abs(h))));
%2-D filtering
sx=imfilter(IM,h,'replicate','conv');


function y = gauss(x,sigma)
%Gaussian
y = exp(-x^2/(2*sigma^2)) / (sigma*sqrt(2*pi));
