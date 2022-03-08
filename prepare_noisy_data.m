%% 1D
%[prefix,~,~] = woundhealing_1d([500,0.05,1,1,1,0],200,1);
[prefix,~,~] = woundhealing_1d([500,0.12,1.5,1.4,1,0],200,1);
load([prefix,'.mat']);

ts=0:dt*drawperframe:T;
sigma=0.05;
cc_noisy_005 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_005,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
sigma=0.01;
cc_noisy_001 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_001,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','-mat','-append');

%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211116_135259_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.02.mat');
cc_seg = double(cc>0.5);
animate_1d(cc_seg,[0,L],drawperframe*dt,'c',[prefix,'_seg'],1);
save([prefix,'.mat'],'cc_seg','-mat','-append');

%% 2D
[prefix,~,~] = woundhealing_2d([500,0.05,1,1,1,0],200,1);
load([prefix,'.mat']);
ts=0:dt*drawperframe:T;
sigma=0.05;
cc_noisy_005 = cc+normrnd(0,sigma,size(cc));
sigma=0.01;
cc_noisy_001 = cc+normrnd(0,sigma,size(cc));
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','-mat','-append');

%% kevin data
load('/home/liuy1/Documents/woundhealing/kevin-data/highDen_phase.mat');
prefix=['/home/liuy1/Documents/woundhealing/simulations/kevindata_highdensity_phase',datestr(datetime('now'), 'yyyymmdd_HHMMSS')];
noisy_data=1-Cdata(1:3:end,1:18:1800,1:18:1800);
animate_2d(noisy_data,[0,3285],[0,3285],1,'C',prefix,1);
save([prefix,'.mat'],'noisy_data','prefix','-mat');