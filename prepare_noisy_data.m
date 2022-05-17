%% 1D
[prefix,~,~] = woundhealing_1d([500,0.05,1,1,1,0],200,1);
%[prefix,~,~] = woundhealing_1d([500,0.12,1.5,1.4,1,0],200,1);
load([prefix,'.mat']);

ts=0:dt*drawperframe:T;
sigma=0.05;
cc_noisy_005 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_005,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
sigma=0.01;
cc_noisy_001 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_001,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
cc_seg = double(cc>0.5);
nFrame=size(cc,1);
areas=zeros(nFrame,1);
for i=1:nFrame
    areas(i)=sum(cc_seg(i,:,:)==0,'all');
end
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','cc_seg','areas','-mat','-append');

%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211116_135259_D0=500,r=0.05,alpha=1,beta=1,gamma=1,n=0,dt=0.02.mat');
cc_seg = double(cc>0.5);
nFrame=size(cc,1);
areas=zeros(nFrame,1);
for i=1:nFrame
    areas(i)=sum(cc_seg(i,:,:)==0,'all');
end
animate_1d(cc_seg,[0,L],drawperframe*dt,'c',[prefix,'_seg'],1);
save([prefix,'.mat'],'cc_seg','areas','-mat','-append');

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
load('/home/liuy1/Documents/woundhealing/kevin-data/highDen_phase_segment.mat');
prefix=['/home/liuy1/Documents/woundhealing/simulations/kevindata_highdensity_phase',datestr(datetime('now'), 'yyyymmdd_HHMMSS')];
noisy_data=1-Cdata(1:3:end,1:18:1800,1:18:1800); %down-sampled is to 100x100 pixel, 1hr bw frames
animate_2d(noisy_data,[0,3285],[0,3285],1,'C',prefix,1);

nFrame=size(noisy_data,1);
areas=zeros(nFrame,1);
for i=1:nFrame
    areas(i)=sum(noisy_data(i,:,:)==0,'all');
end

save([prefix,'.mat'],'noisy_data','areas','prefix','-mat');

%% cleaned kevin data
load('kevin-data/highDen_phase_clean.mat');
prefix=['simulations/kevindata_hd_phase_clean',datestr(datetime('now'), 'yyyymmdd_HHMMSS')];
noisy_data=1-Cdata(1:3:end,1:18:1800,1:18:1800);
animate_2d(noisy_data,[0,3285],[0,3285],[0,1.2],1,'C',prefix,1);
save([prefix,'.mat'],'noisy_data','prefix','-mat');

%% 1D porus fisher
[prefix,~,~] = woundhealing_1d([1000,0.1,1,1,1,1],200,1);
load([prefix,'.mat']);

ts=0:dt*drawperframe:T;
sigma=0.05;
cc_noisy_005 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_005,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
sigma=0.01;
cc_noisy_001 = cc+normrnd(0,sigma,size(cc));
animate_1d(cc_noisy_001,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma)],1);
cc_seg = double(cc>0.5);
animate_1d(cc_seg,[0,L],drawperframe*dt,'c',[prefix,'_threshold'],1);
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','cc_seg','-mat','-append');