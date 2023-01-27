figg=figure('Position',[50,50,1200,900],'color','w');
%sgtitle('xy1, 1D');
num_params=7;
ranges={[1270,1570],[0.09,0.28],[1.1,1.4],[1.1,1.4],[1.1,1.3],[0,0.1],[2610,2710]};
range_width=[80,0.04,1,1,0.1,0.02,20];
t = tiledlayout(4,5);
%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat')
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
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xlim(xrange);
    xticks(xrange);
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
end
nexttile;set(gca,'visible','off');
%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1546,0.27,1,1,1,0.07,2628,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat')
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
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
end

%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1400,0.246,1,1,1,0,2616,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat')
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,5];
nexttile;
text(-1,0,{'Porous','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+8);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
end

%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1423.47,0.101,1.173,1.355,1,0,2701.4,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat')
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,3,4];
nexttile;
text(-1,0,{'Generalized','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:4
    param=param_inds(i);
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    
    if i<=3
    nexttile;
    hold on
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    xlim(xrange);
    xticks(xrange);
    xtickformat('%.4g');
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    else
    nexttile;
    hold on
    plot(xx,yy,'b-','DisplayName',param_names{param});
    h=plot([-1e6,1e6],[-1.92,-1.92],'k-');
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    ylim([-2.5,0]);
    i=5;
    
    param=param_inds(i);
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'m-','DisplayName',param_names{param});
    xlim(ranges{param});
    xticks([ranges{param}(1),ranges{param}(2)]);
    yticks([-2,0]);
    
    %xlabel('$\alpha, \beta$','Interpreter','latex');
    legend('Location','eastoutside');
    end
end

%%
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 18);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end

t.TileSpacing = 'none';
t.Padding = 'none';

%%
saveas(figg,'figure/xy1_2d_figtable2.fig');
saveas(figg,'figure/xy1_2d_figtable2.png');