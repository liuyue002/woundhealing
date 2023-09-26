%% Generate 1D synthetic data
nx=150;
ic=zeros(nx,1);
k=2600;
ic(1:60)=k;
params=[1800,0.17,1,1,2,0,2600];
[prefix,~,~] = woundhealing_1d(params,[25,1/30,10,2190,nx,0],1,ic,nan);
load([prefix,'.mat']);

ts=0:dt*drawperframe:T;
sigma_low=20;
cc_noisy_low = cc+normrnd(0,sigma_low,size(cc));
animate_1d(cc_noisy_low,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma_low)],1);
sigma_high=400;
cc_noisy_high = cc+normrnd(0,sigma_high,size(cc));
animate_1d(cc_noisy_high,[0,L],drawperframe*dt,'c',[prefix,'_noise=',num2str(sigma_high)],1);
cc_seg = double(cc>0.5);
nFrame=size(cc,1);
areas=zeros(nFrame,1);
for i=1:nFrame
    areas(i)=sum(cc_seg(i,:,:)==0,'all');
end
save([prefix,'.mat'],'cc_noisy_low','cc_noisy_high','cc_seg','areas','sigma_low','sigma_high','-mat','-append');
