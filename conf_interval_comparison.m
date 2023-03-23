%%
%permutation=eye(8);
permutation = [1,0,0,0,0,0,0,0;
               0,1,0,0,0,0,0,0;
               0,0,0,0,1,0,0,0;
               0,0,0,0,0,1,0,0;
               0,0,1,0,0,0,0,0;
               0,0,0,1,0,0,0,0;
               0,0,0,0,0,0,1,0;
               0,0,0,0,0,0,0,1;];

%% standard Fisher

% fig=figure('color','w');
% t = tiledlayout(1,3);
% nexttile;
% Dplot=boxchart(zeros(2,8));
% xlabel('Experiment');
% title('$D_0$','Interpreter','latex');
% nexttile;
% rplot=boxchart(zeros(2,8));
% xlabel('Experiment');
% title('$r$','Interpreter','latex');
% nexttile;
% Kplot=boxchart(zeros(2,8));
% xlabel('Experiment');
% title('$K$','Interpreter','latex');

files={
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat',...
'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1157,0.29,1,1,1,0,2550,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',...
'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,8.mat',...
'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1161,0.32,1,1,1,0,2306,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1117,0.3,1,1,1,0,2521,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1252,0.28,1,1,1,0,2788,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',...
'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1845,0.226,1,1,1,0,2418,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',...
'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1448,0.26,1,1,1,0,2294,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
};

D_ranges=zeros(2,8);
r_ranges=zeros(2,8);
K_ranges=zeros(2,8);
D_mles=zeros(1,8);
r_mles=zeros(1,8);
K_mles=zeros(1,8);

for file=1:8
    load(['simulations/',files{file}]);
    zs = cell(num_params,1);
    conf_interval=nan(num_params,1);
    for param=1:num_params
        if fixed(param)
            continue;
        end
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        zs{param}=interp_zero(xx,yy+1.92);
    end
    % Dplot.YData(:,file)=zs{1};
    % rplot.YData(:,file)=zs{2};
    % Kplot.YData(:,file)=zs{7};
    D_ranges(:,file)=zs{1};
    r_ranges(:,file)=zs{2};
    K_ranges(:,file)=zs{7};
    D_mles(file)=overall_minimizer(1);
    r_mles(file)=overall_minimizer(2);
    K_mles(file)=overall_minimizer(3);
end
close all;

K_ranges(:,6)=[2786.81428519868,2789.83554244494];
%%
addpath('/home/liuy1/Documents/woundhealing/rangebar');
barwidth=0.4;
figg=figure('color','w','Position',[100,100,1230,440]);
t = tiledlayout(1,3);
nexttile;
Dplot=rangebar(D_ranges*permutation,barwidth);
Dplot.FaceColor='flat';
Dplot.CData=[1,1,0,0,1,1,0,0]*permutation;
xlabel('Experiment','Interpreter','latex');
title('$D_0$','Interpreter','latex');
nexttile;
rplot=rangebar(r_ranges*permutation,barwidth);
rplot.FaceColor='flat';
rplot.CData=[1,1,0,0,1,1,0,0]*permutation;
xlabel('Experiment','Interpreter','latex');
title('$r$','Interpreter','latex');
nexttile;
Kplot=rangebar(K_ranges*permutation,barwidth);
Kplot.FaceColor='flat';
Kplot.CData=[1,1,0,0,1,1,0,0]*permutation;
xlabel('Experiment','Interpreter','latex');
title('$K$','Interpreter','latex');
%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/conf_interval_compare_rDk_permuted.fig');
saveas(figg,'figure/conf_interval_compare_rDk_permuted.png');
saveas(figg,'figure/conf_interval_compare_rDk_permuted.eps','epsc');

%% Porous Fisher
files={
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1546,0.27,1,1,1,0.07,2628,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat',...
'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1527,0.28,1,1,1,0.1,2561,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat',...
'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[4100,0.274,1,1,1,0.567,2377,],kevindata,threshold=-1,tskip=1,xskip=1,12.mat',...
'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[2713,0.3,1,1,1,0.4,2332,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.31,1,1,1,0.05,2524,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1439,0.28,1,1,1,0.05,2793,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[10061,0.164,1,1,1,1.044,2626,],kevindata,threshold=-1,tskip=1,xskip=1,6.mat',...
'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[3504,0.24,1,1,1,0.45,2336,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
};

D_ranges=zeros(2,8);
r_ranges=zeros(2,8);
K_ranges=zeros(2,8);
n_ranges=zeros(2,8);
D_mles=zeros(1,8);
r_mles=zeros(1,8);
K_mles=zeros(1,8);
n_mles=zeros(1,8);

for file=1:8
    load(['simulations/',files{file}]);
    zs = cell(num_params,1);
    conf_interval=nan(num_params,1);
    for param=1:num_params
        if fixed(param)
            continue;
        end
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        zs{param}=interp_zero(xx,yy+1.92);
    end
    % Dplot.YData(:,file)=zs{1};
    % rplot.YData(:,file)=zs{2};
    % Kplot.YData(:,file)=zs{7};
    D_ranges(:,file)=zs{1};
    r_ranges(:,file)=zs{2};
    K_ranges(:,file)=zs{7};
    n_ranges(:,file)=zs{6};
    D_mles(file)=overall_minimizer(1);
    r_mles(file)=overall_minimizer(2);
    K_mles(file)=overall_minimizer(4);
    n_mles(file)=overall_minimizer(3);
end
close all;

D_ranges(:,7)=[9896.02467981219,10230.8298624504];

%%
addpath('/home/liuy1/Documents/woundhealing/rangebar');
barwidth=0.4;
figg=figure('color','w','Position',[100,100,1620,440]);
t = tiledlayout(1,4);
nexttile;
Dplot=rangebar(D_ranges*permutation,barwidth);
Dplot.FaceColor='flat';
Dplot.CData=[1,1,0,0,1,1,0,0]*permutation;
ylim([0,12000]);
yticks([0,4000,8000,12000]);
xlabel('Experiment','Interpreter','latex');
title('$D_0$','Interpreter','latex');
nexttile;
rplot=rangebar(r_ranges*permutation,barwidth);
rplot.FaceColor='flat';
rplot.CData=[1,1,0,0,1,1,0,0]*permutation;
ylim([0.14,0.35]);
yticks([0.14,0.21,0.28,0.35]);
xlabel('Experiment','Interpreter','latex');
title('$r$','Interpreter','latex');
nexttile;
Kplot=rangebar(K_ranges*permutation,barwidth);
Kplot.FaceColor='flat';
Kplot.CData=[1,1,0,0,1,1,0,0]*permutation;
ylim([2200,2800]);
yticks([2200,2400,2600,2800]);
xlabel('Experiment','Interpreter','latex');
title('$K$','Interpreter','latex');
nexttile;
nplot=rangebar(n_ranges*permutation,barwidth);
nplot.FaceColor='flat';
nplot.CData=[1,1,0,0,1,1,0,0]*permutation;
ylim([0,1.2]);
yticks([0,0.4,0.8,1.2]);
xlabel('Experiment','Interpreter','latex');
title('$\eta$','Interpreter','latex');

%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 20);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/conf_interval_compare_rDnk_permuted.fig');
saveas(figg,'figure/conf_interval_compare_rDnk_permuted.png');
saveas(figg,'figure/conf_interval_compare_rDnk_permuted.eps','epsc');

%% Richards

files={
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1400,0.246,1,1,1,0,2616,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',...
'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[916.817,0.406174,1,1,0.630784,0,2561.23,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',...
'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2697.13,0.136,1,1,7.805,0,2335.76,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',...
'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2290,0.14,1,1,8.1,0,2287,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1293,0.26,1,1,1,0,2514,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1565,0.21,1,1,1.64,0,2774,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[3179.77,0.1057,1,1,8.9999,0,2353.07,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',...
'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2666,0.12,1,1,8.9,0,2240,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',...
};

D_ranges=zeros(2,8);
r_ranges=zeros(2,8);
K_ranges=zeros(2,8);
g_ranges=zeros(2,8);
D_mles=zeros(1,8);
r_mles=zeros(1,8);
K_mles=zeros(1,8);
g_mles=zeros(1,8);

for file=1:8
    load(['simulations/',files{file}]);
    zs = cell(num_params,1);
    conf_interval=nan(num_params,1);
    for param=1:num_params
        if fixed(param)
            continue;
        end
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        zs{param}=interp_zero(xx,yy+1.92);
    end
    % Dplot.YData(:,file)=zs{1};
    % rplot.YData(:,file)=zs{2};
    % Kplot.YData(:,file)=zs{7};
    D_ranges(:,file)=zs{1};
    r_ranges(:,file)=zs{2};
    K_ranges(:,file)=zs{7};
    g_ranges(:,file)=zs{5};
    D_mles(file)=overall_minimizer(1);
    r_mles(file)=overall_minimizer(2);
    K_mles(file)=overall_minimizer(4);
    g_mles(file)=overall_minimizer(3);
end
close all;
K_ranges(2,6)=2776.5;
g_ranges(:,7)=[8.6,10];
g_ranges(:,8)=[8.7,10]; % 10 stands for infinity

%%
addpath('/home/liuy1/Documents/woundhealing/rangebar');
barwidth=0.4;
figg=figure('color','w','Position',[100,100,1620,440]);
t = tiledlayout(1,4);
nexttile;
Dplot=rangebar(D_ranges*permutation,barwidth);
Dplot.FaceColor='flat';
Dplot.CData=[1,1,0,0,1,1,0,0]*permutation;
ylim([800,3200]);
yticks([800,1600,2400,3200]);
xlabel('Experiment','Interpreter','latex');
title('$D_0$','Interpreter','latex');
nexttile;
rplot=rangebar(r_ranges*permutation,barwidth);
rplot.FaceColor='flat';
rplot.CData=[1,1,0,0,1,1,0,0]*permutation;
xlabel('Experiment','Interpreter','latex');
title('$r$','Interpreter','latex');
nexttile;
Kplot=rangebar(K_ranges*permutation,barwidth);
Kplot.FaceColor='flat';
Kplot.CData=[1,1,0,0,1,1,0,0]*permutation;
xlabel('Experiment','Interpreter','latex');
title('$K$','Interpreter','latex');
nexttile;

g_ranges2=g_ranges*permutation; % want to break the y axis
g_ranges2(:,5:8)=g_ranges2(:,5:8)-4;
gplot=rangebar(g_ranges2,barwidth);
gplot.FaceColor='flat';
gplot.CData=[1,1,0,0,1,1,0,0]*permutation;
hold on;
plot([-10,10],[2.5,2.5],'--k');
plot([-10,10],[5.5,5.5],'--k');
yticks([0,2,3,5,6]);
yticklabels({'0','2','7','9','\infty'});
xlabel('Experiment','Interpreter','latex');
title('$\gamma$','Interpreter','latex');



%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 20);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/conf_interval_compare_rDgk_permuted.fig');
saveas(figg,'figure/conf_interval_compare_rDgk_permuted.png');
saveas(figg,'figure/conf_interval_compare_rDgk_permuted.eps','epsc');

%% Gen F

files={
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1423.47,0.101,1.173,1.355,1,0,2701.4,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',...
'kevindata_circle_xy2_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[826.96,0.2383,1.1091,2.1168,1,0,2893.54,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',...
'kevindata_circle_xy5_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1376,0.1998,1.0505,0.8669,1,0,2500,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',...
'kevindata_circle_xy6_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1551.58,0.10278,1.1489,1.07007,1,0,2797.02,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',...
};

D_ranges=zeros(2,4);
r_ranges=zeros(2,4);
K_ranges=zeros(2,4);
a_ranges=zeros(2,4);
b_ranges=zeros(2,4);
D_mles=zeros(1,4);
r_mles=zeros(1,4);
K_mles=zeros(1,4);
a_mles=zeros(1,4);
b_mles=zeros(1,4);

for file=1:4
    load(['simulations/',files{file}]);
    zs = cell(num_params,1);
    conf_interval=nan(num_params,1);
    for param=1:num_params
        if fixed(param)
            continue;
        end
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        zs{param}=interp_zero(xx,yy+1.92);
    end
    % Dplot.YData(:,file)=zs{1};
    % rplot.YData(:,file)=zs{2};
    % Kplot.YData(:,file)=zs{7};
    D_ranges(:,file)=zs{1};
    r_ranges(:,file)=zs{2};
    K_ranges(:,file)=zs{7};
    a_ranges(:,file)=zs{3};
    b_ranges(:,file)=zs{4};
    D_mles(file)=overall_minimizer(1);
    r_mles(file)=overall_minimizer(2);
    K_mles(file)=overall_minimizer(5);
    a_mles(file)=overall_minimizer(3);
    b_mles(file)=overall_minimizer(4);
end
close all;

%%
addpath('/home/liuy1/Documents/woundhealing/rangebar');
barwidth=0.4;
figg=figure('color','w','Position',[100,100,1840,400]);
t = tiledlayout(1,5);
nexttile;
Dplot=rangebar(D_ranges,barwidth);
Dplot.FaceColor='yellow';
%Dplot.CData=[1,1,1,1];
ylim([700,1600]);
yticks([700,1000,1300,1600]);
xlabel('Experiment','Interpreter','latex');
title('$D_0$','Interpreter','latex');
nexttile;
rplot=rangebar(r_ranges,barwidth);
rplot.FaceColor='yellow';
%rplot.CData=[1,1,1,1];
ylim([0.08,0.26]);
yticks([0.08,0.14,0.20,0.26]);
xlabel('Experiment','Interpreter','latex');
title('$r$','Interpreter','latex');
nexttile;
Kplot=rangebar(K_ranges,barwidth);
Kplot.FaceColor='yellow';
%Kplot.CData=[1,1,1,1];
ylim([2400,3000]);
yticks([2400,2600,2800,3000]);
xlabel('Experiment','Interpreter','latex');
title('$K$','Interpreter','latex');
nexttile;
aplot=rangebar(a_ranges,barwidth);
aplot.FaceColor='yellow';
%aplot.CData=[1,1,1,1];
ylim([1,1.3]);
yticks([1,1.1,1.2,1.3]);
xlabel('Experiment','Interpreter','latex');
title('$\alpha$','Interpreter','latex');
nexttile;
bplot=rangebar(b_ranges,barwidth);
bplot.FaceColor='yellow';
%bplot.CData=[1,1,1,1];
ylim([0.8,2.3]);
yticks([0.8,1.3,1.8,2.3]);
xlabel('Experiment','Interpreter','latex');
title('$\beta$','Interpreter','latex');

%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/conf_interval_compare_rDabk_permuted.fig');
saveas(figg,'figure/conf_interval_compare_rDabk_permuted.png');
saveas(figg,'figure/conf_interval_compare_rDabk_permuted.eps','epsc');