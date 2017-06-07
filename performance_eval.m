function [CC,SROCC,RMSE]=performance_eval(x,y,isShow)
% ������������
%% logistic transform
% modelfun = @(b,x)((b(1)-b(2))./(1+exp((x-b(3))./b(4)))+b(2)); % �����logistic����
modelfun = @(b,x)(b(1).*(1/2-1./(1+exp(b(2).*(x-b(3)))))+b(4).*x+b(5));% �����

rng('default') % for reproducibility

% opts = statset('nlinfit');
% opts.RobustWgtFun = 'bisquare';

beta0 = [1;1;0;1;1];
beta = nlinfit(x,y,modelfun,beta0);
y_pred=modelfun(beta,x);
%% plot figure
% figure,plot(y,'*');
% hold on;
% plot(y_pred);

%% Ƥ��ɭ���ϵ��
% mu_y1=mean(y);
% mu_y2=mean(y_pred);
% sigma1=sqrt(mean((y-mu_y1).^2));
% sigma2=sqrt(mean((y_pred-mu_y2).^2));
% CC2=mean((y-mu_y1).*(y_pred-mu_y2)/(sigma1*sigma2));
CC=corr(y,y_pred);% Ƥ��ɭ���ϵ��
%% ˹Ƥ�����ȼ����ϵ��
% [B1,I1]=sort(y);
% N=length(y);
% rank1=zeros(1,N);
% [B2,I2]=sort(y_pred);
% rank2=zeros(1,N);
% 
% for i=1:N
%     rank1(I1(i))=i;
%     rank2(I2(i))=i;
% end
% SROCC2=1-6*sum((rank1-rank2).^2)/(N*(N^2-1));
SROCC=corr(y,y_pred,'type','Spearman');
%% ��������� RMSE
RMSE=sqrt(mean((y-y_pred).^2));
%% ��ͼ��ʾ
if(isShow==1)
    figure,
    plot(x,y,'b*');
    hold on;
    plot(y_pred,y,'rx');
    ylabel('MOS');
    legend('���ǰ','��Ϻ�');
end
