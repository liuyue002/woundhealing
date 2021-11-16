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
save([prefix,'.mat'],'cc_noisy_005','cc_noisy_001','-mat','-append');