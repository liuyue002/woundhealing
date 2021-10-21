load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211015_163234_Dc=500_r=0.05_n=0_alpha=1_beta=1.mat');
%l=log_likelihood_1d(cc_noisy,1,1,0.05);
% the optimization parameters are Dc, r, alpha, beta, sigma2
noise_strength=0.01;
noisy_data=cc_noisy_001;
t_skip=10;
x_skip=30;
true_params=[Dc,r,alpha,beta,noise_strength];
lb=true_params*0.8;
ub=true_params*1.2;
param_names={'Dc','r','alpha','beta','sigma2'};
num_params=size(true_params,2);

%%
% fix everything else other than D,r
numpts=20;
Dcs=linspace(lb(1),ub(1),numpts);
rs=linspace(lb(2),ub(2),numpts);
ls=zeros(numpts,numpts);
for i=1:numpts
    for j=1:numpts
        ls(i,j)=log_likelihood_1d(noisy_data,T,Dcs(i),rs(j),true_params(3),true_params(4),true_params(5),t_skip,x_skip);
    end
end

%%
figtitle=['D_c vs r, noise=',num2str(noise_strength),', fixed alpha,beta,sigma','tskip=',num2str(t_skip),', xskip=',num2str(x_skip)];
fig=figure('color','w');
imagesc(ls);
set(gca,'YDir','normal');
xlabel('r');
ylabel('D_c');
set(gca,'XTick',[1,numpts]);
set(gca,'XTickLabel',{lb(2),ub(2)});
set(gca,'YTick',[1,numpts]);
set(gca,'YTickLabel',{lb(1),ub(1)});
colorbar;
title(figtitle);
saveas(fig,[prefix,figtitle,'.png']);
%%
save([prefix,figtitle,'.mat'],'-mat');