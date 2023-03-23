%load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[1,1,1,1,1,1,0,],D0,r_1.mat');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,1,0,],D0,r_2.mat');
[X,Y]=meshgrid(p1s,p2s);
figboth=figure;
surf(X'-1,Y'-0.000125,ls-max(ls,[],'all'),'EdgeColor','none');
view(2);
xlim([1270,1349]);
ylim([0.262,0.2718]);
xlabel('D_0');
ylabel('r');
zlabel('l');
caxis([-20,0]);
colorbar;

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,mcmc,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],1.mat');
figure(figboth);
burnin=1000;
hold on;
plot(samples(burnin:end,1),samples(burnin:end,2),'r.','Markersize',3);

saveas(figboth,'figure/mcmc_plike_comparison_rDk.fig');
saveas(figboth,'figure/mcmc_plike_comparison_rDk.png');

%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[1,1,1,1,1,1,0,],D0,r_1.mat');

[X,Y]=meshgrid(p1s,p2s);
figboth=figure;
surf(X',Y',ls-max(ls,[],'all'),'EdgeColor','none');
view(2);
xlim([1250,1350]);
ylim([0.255,0.28]);
xlabel('D_0');
ylabel('r');
zlabel('l');
caxis([-20,0]);
colorbar;

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,mcmc,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],1.mat');
figure(figboth);
burnin=2000;
hold on;
plot(samples(burnin:end,1),samples(burnin:end,2),'r.','Markersize',2);

saveas(figboth,'figure/mcmc_plike_comparison_rDabk.fig');
saveas(figboth,'figure/mcmc_plike_comparison_rDabk.png');