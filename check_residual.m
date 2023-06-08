load('simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat');
[~,cc_mle,~] = woundhealing_2d(optimal_param_vals,numeric_params,0,ic);
residuals=noisy_data-cc_mle;
residuals=reshape(residuals,1,[]);
close all;
%%
figure;
histfit(residuals,50);
xlim([-1500,1500]);
ylim([0,7e5]);
%%
noisy_data_pts=reshape(noisy_data,1,[]);
figure;
histfit(noisy_data_pts);
xlim([0,4000]);
ylim([0,1e5]);
%%
figure;
h=histogram(residuals,[-1680:160:1680]);
pd=fitdist(residuals','Normal');
xx=-1500:10:1500;
pdfs=pdf(pd,xx);
hold on;
plot(xx,pdfs/max(pdfs)*max(h.Values),'-r');
%%
figure;
h=histogram(residuals,[-1800:400:1800],'Normalization','probability');
pd=fitdist(residuals','Normal');
xx=-1500:10:1500;
pdfs=pdf(pd,xx);
hold on;
plot(xx,pdfs*400,'-r');

%% excludde the region away from cell pop
residuals_nonzero=residuals(cc_mle>100);
figure;
h=histogram(residuals_nonzero,[-1800:400:1800],'Normalization','probability');
pd=fitdist(residuals_nonzero','Normal');
xx=-1500:10:1500;
pdfs=pdf(pd,xx);
hold on;
plot(xx,pdfs*400,'-r');

%%
%[isnotnormal,p,ksstat,cv]=kstest(residuals_nonzero);
[isnotnormal,p,kstat,critval]=lillietest(residuals_nonzero);

figure;
cdfplot(residuals_nonzero);
hold on;
plot(xx,cdf(pd,xx));