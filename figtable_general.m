figg=figure('Position',[50,50,1200,900],'color','w');
%sgtitle('xy1, 1D');
num_params=7;
ranges={[1240,1590],[0.08,0.30],[1.1,1.4],[1.1,1.4],[1.1,1.5],[0,0.1],[2600,2720]};
range_width=[80,0.04,1,1,0.1,0.02,20];
t = tiledlayout(4,5);
%t = tiledlayout(3,5);
%%
experiment=1;dim=2;

% files={
% 'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=1,xskip=1,202302061140.mat',...
% 'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.0218,2622,],kevindata,threshold=-1,tskip=1,xskip=1,202302061142.mat',...
% 'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=1,xskip=1,202302061146.mat',...
% 'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat',...
% };

files={
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat',...
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1546,0.27,1,1,1,0.07,2628,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat',...
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1400,0.246,1,1,1,0,2616,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',...
'kevindata_circle_xy1_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1423.47,0.101,1.173,1.355,1,0,2701.4,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',...
};

% files={
% 'kevindata_circle_xy2_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1211,0.278,1,1,1,0,2551,],kevindata,threshold=-1,tskip=1,xskip=1,202302171425.mat',...
% 'kevindata_circle_xy2_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1650,0.267,1,1,1,0.127,2564,],kevindata,threshold=-1,tskip=1,xskip=1,202302171427.mat',...
% 'kevindata_circle_xy2_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[981,0.367,1,1,0.681,0,2560,],kevindata,threshold=-1,tskip=1,xskip=1,202302171430.mat',...
% 'kevindata_circle_xy2_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[806,0.278,1.074,2.015,1,0,2873,],kevindata,threshold=-1,tskip=1,xskip=1,202302171433.mat',...
% };

% files={
% 'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1157,0.29,1,1,1,0,2550,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',
% 'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1527,0.28,1,1,1,0.1,2561,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat',
% 'kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[916.817,0.406174,1,1,0.630784,0,2561.23,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',
% 'kevindata_circle_xy2_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[826.96,0.2383,1.1091,2.1168,1,0,2893.54,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',
% };

% files={
% 'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,8.mat',
% 'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[4100,0.274,1,1,1,0.567,2377,],kevindata,threshold=-1,tskip=1,xskip=1,12.mat',
% 'kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2697.13,0.136,1,1,7.805,0,2335.76,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',
% '',
% };

% files={
% 'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1161,0.32,1,1,1,0,2306,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[2713,0.3,1,1,1,0.4,2332,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2290,0.14,1,1,8.1,0,2287,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% '',
% };

% files={
% 'kevindata_circle_xy5_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1107,0.317,1,1,1,0,2518,],kevindata,threshold=-1,tskip=1,xskip=1,202302171435.mat',
% 'kevindata_circle_xy5_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1228,0.313,1,1,1,0.03,2520,],kevindata,threshold=-1,tskip=1,xskip=1,202302171436.mat',
% 'kevindata_circle_xy5_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1200,0.3,1,1,1.16,0,2514,],kevindata,threshold=-1,tskip=1,xskip=1,202302221117.mat',
% 'kevindata_circle_xy5_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1146,0.239,1.05,1.1,1,0,2534,],kevindata,threshold=-1,tskip=1,xskip=1,202302161447.mat',
% };

% files={
% 'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1117,0.3,1,1,1,0,2521,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.31,1,1,1,0.05,2524,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1293,0.26,1,1,1,0,2514,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_circle_xy5_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1376,0.1998,1.0505,0.8669,1,0,2500,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% };

% files={
% 'kevindata_circle_xy6_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1238,0.284,1,1,1,0,2784,],kevindata,threshold=-1,tskip=1,xskip=1,202302221120.mat',
% 'kevindata_circle_xy6_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1406,0.28,1,1,1,0.05,2789,],kevindata,threshold=-1,tskip=1,xskip=1,202302171441.mat',
% 'kevindata_circle_xy6_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1465,0.227,1,1,1.42,0,2775,],kevindata,threshold=-1,tskip=1,xskip=1,202302171445.mat',
% 'kevindata_circle_xy6_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1415,0.146,1.1,1.08,1,0,2800,],kevindata,threshold=-1,tskip=1,xskip=1,202302171446.mat',
% };

% files={
% 'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1252,0.28,1,1,1,0,2788,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
% 'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1439,0.28,1,1,1,0.05,2793,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1565,0.21,1,1,1.64,0,2774,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_circle_xy6_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1551.58,0.10278,1.1489,1.07007,1,0,2797.02,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',
% };

% files={
% 'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1845,0.226,1,1,1,0,2418,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
% 'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[10061,0.164,1,1,1,1.044,2626,],kevindata,threshold=-1,tskip=1,xskip=1,6.mat',
% 'kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[3179.77,0.1057,1,1,8.9999,0,2353.07,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',
% '',
% };

% files={
% 'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1448,0.26,1,1,1,0,2294,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[3504,0.24,1,1,1,0.45,2336,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
% 'kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2666,0.12,1,1,8.9,0,2240,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
% '',
% };

% files={
% '',
% '',
% '',
% '',
% };
%%
load(['simulations/',files{1}]);
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7];
nexttile;
text(-1,0,{'Standard','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:3
    param=param_inds(i);
    %subplot(4,4,i);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if i==3 && experiment==6 && dim==2
        load('simulations/kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1252,0.28,1,1,1,0,2788,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat','xx','yy');
    end

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    %xrange=[min(xx),max(xx)];
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end
nexttile;set(gca,'visible','off');
%%
load(['simulations/',files{2}]);
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,6];
nexttile;
text(-1,0,{'Porous','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+4);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if i==3 && experiment==5 && dim== 2
        xx=[xx,2526.3];
        yy=[yy,-4];
    end

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    %xrange=[min(xx),max(xx)];
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

%%
load(['simulations/',files{3}]);
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,5];
nexttile;
text(-1,0,{'Richards'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+8);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if i==3 && experiment==6 && dim==2
        load('simulations/kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1565,0.21,1,1,1.64,0,2774,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat','xx','yy');
    end

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    %xrange=[min(xx),max(xx)];
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

%%
load(['simulations/',files{4}]);
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,3,4];
nexttile;
text(-1,0,{'Generalised','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:4
    param=param_inds(i);
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if i==3 && experiment==5 && dim== 2
        xx=xx([1:15,17:32,34:end]);
        yy=yy([1:15,17:32,34:end]);
    end

    if i<=3
    nexttile;
    hold on
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    %xrange=[min(xx),max(xx)];
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
    else
    nexttile;
    hold on
    plot(xx,yy,'b-','DisplayName',param_names{param});
    h=plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--b');
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    h=plot([-1e6,1e6],[-1.92,-1.92],'k-');
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    ylabel('$l$','Interpreter','latex');
    axis('square');
    ylim([-2.5,0]);
    i=5;

    param=param_inds(i);
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'m-','DisplayName',param_names{param});
    h=plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--m');
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    %xrange=[1.0,1.4];
    %xrange=[0.5,2.0];
    xrange=[1.0,1.4];
    xlim(xrange);
    xticks(xrange);
    yticks([-2,0]);
    xtickangle(0);

    %xlabel('$\alpha, \beta$','Interpreter','latex');
    legend('Location','eastoutside');
    end
end

%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end

%t.TileSpacing = 'none';
t.TileSpacing = 'tight';
t.Padding = 'none';

%%

saveas(figg,sprintf('figure/xy%d_%dd_figtable_2_manualxlim.fig',experiment,dim));
saveas(figg,sprintf('figure/xy%d_%dd_figtable_2_manualxlim.png',experiment,dim));
saveas(figg,sprintf('figure/xy%d_%dd_figtable_2_manualxlim.eps',experiment,dim),'epsc');