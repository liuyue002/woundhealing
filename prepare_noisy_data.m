%load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211012_144816_Dc=1_r=1_n=0_alpha=1_beta=1.mat');
%prefix='/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211012_144816_Dc=1_r=1_n=0_alpha=1_beta=1';

%[prefix,~] = woundhealing_1d(1,1,1,1,50,0,0,1);
%[prefix,~,~] = woundhealing_1d(500,0.12,1.5,1.4,200,0,0,1);
[prefix,~,~] = woundhealing_1d([500,0.12,1.5,1.4,1,0],200,1);
load([prefix,'.mat']);

ts=0:dt*drawperframe:T;
sigma2=0.05;
cc_noisy_005 = cc+normrnd(0,sigma2,size(cc));
animate_1d(cc_noisy_005,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma2)],1);
sigma2=0.01;
cc_noisy_001 = cc+normrnd(0,sigma2,size(cc));
animate_1d(cc_noisy_001,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma2)],1);
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','sigma2','-mat','-append');

%%
% %load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211015_163234_Dc=500_r=0.05_n=0_alpha=1_beta=1.mat')
% [prefix,~,~] = woundhealing_1d(500,0.05,1,1,200,0,0,1);
% load([prefix,'.mat']);
% ts=0:dt*drawperframe:T;
% sigma2=0.05;
% cc_noisy_005 = cc+normrnd(0,sigma2,size(cc));
% animate_1d(cc_noisy_005,[0,L],drawperframe*dt,'c',[prefix,'_noise=,',num2str(sigma2)],1);
% sigma2=0.01;
% cc_noisy_001 = cc+normrnd(0,sigma2,size(cc));
% animate_1d(cc_noisy_001,[0,L],drawperframe*dt,'c',[prefix,'_noise=,',num2str(sigma2)],1);
% save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','sigma2','-mat','-append');