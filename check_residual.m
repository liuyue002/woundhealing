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
xlabel('Residual',Interpreter='latex');
xlabel('Normalised frequency',Interpreter='latex');
%%
figure;
h=histogram(residuals,[-1800:400:1800],'Normalization','probability',HandleVisibility='off');
pd=fitdist(residuals','Normal');
xx=-1500:10:1500;
pdfs=pdf(pd,xx);
hold on;
plot(xx,pdfs*400,'-r',DisplayName='Fitted normal distribution');
legend;
xlabel('Residual',Interpreter='latex');
ylabel('Normalised frequency',Interpreter='latex');

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

%% as the referee suggests
residuals1=noisy_data-cc_mle;
residuals1=residuals1(2:end,:,:);
residuals1=reshape(residuals1,1,[]);
cc_mle1=reshape(cc_mle(2:end,:,:),1,[]);
figure;
plot(cc_mle1,residuals1,'.');
xlabel('Model density',Interpreter='latex');
ylabel('Residual',Interpreter='latex');
ylim([-3000,5000]);
biggerFont(gca);


%% residual visualisation
residuals2d=noisy_data-cc_mle;
residuals2d1=squeeze(residuals2d(60,:,:));
figresidual=figure;
ax=gca;
s=surf(residuals2d1,'EdgeColor','none');
view(2);
axis off;
ax.Position=[0.113363095328034 0.11 0.675818452917128 0.815];
cb=colorbar;
cb.Position=[0.81,0.11,0.025,0.816];
biggerFont(gcf,20);
saveas(figresidual,'figure/residual_t=20.eps','epsc');
saveas(figresidual,'figure/residual_t=20.fig');

%% moran's I

residuals2d2=squeeze(residuals2d(60,40:120,40:120)); % should be 81x81
% weight: 8 neighbors are 1, otherwise 0
nx=size(residuals2d2,1);
residual_mean = mean(residuals2d2,'all');

numerator=0;
denominator=0;
moment4=0;
ww=zeros(nx,nx,nx,nx);
for i=2:nx-1
    for j=2:nx-1
        for k=-1:1
            for l=-1:1
                if (k~=0) && (l~=0)
                    numerator = numerator + (residuals2d2(i,j)-residual_mean)*(residuals2d2(i+k,j+l)-residual_mean);
                    ww(i,j,i+k,i+l)=1;
                end
            end
        end
        denominator = denominator + (residuals2d2(i,j)-residual_mean)^2;
        moment4 = moment4+ (residuals2d2(i,j)-residual_mean)^4;
    end
end
N=(nx-2)^2;
%W=N*8;
moranI=(N/W)*numerator/denominator;

ww2=reshape(ww,nx^2,nx^2);
W=sum(ww2,'all');

EI= -1/(N-1);
s1=(1/2)*32*N;
s2=N*16^2;
% s1=0;
% s2=0;
% for i=1:nx^2
%     s2tmp=0;
%     for j=1:nx^2
%         s1 = s1+(ww2(i,j)+ww2(j,i))^2;
%         s2tmp = s2tmp+ww2(i,j)+ww2(j,i);
%     end
%     s2=s2+s2tmp^2;
% end
% s1=s1/2;
s3=N*moment4/denominator^2;
s4=(N^2-3*N+3)*s1-N*s2+3*W^2;
s5=(N^2-N)*s1-2*N*s2+6*W^2;
VarI=(N*s4-s3*s5)/((N-1)*(N-2)*(N-2)*W^2)-EI^2;

z=(moranI-EI)/VarI;
p=normcdf(z);