figg=figure('Position',[50,50,1200,900],'color','w');
%sgtitle('xy1, 1D');
num_params=7;
ranges={[1050,1550],[0.15,0.45],[0.9,1.1],[0.8,1.2],[0.8,1.6],[0,0.05],[2580,2620]};
t = tiledlayout(4,5);
%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20221110_142214_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.0333_noise=400,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2600,],threshold=-1,tskip=1,xskip=1,2.mat');
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
    plot([true_params(param),true_params(param)],[-10,10],':g'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks([ranges{param}(1),ranges{param}(2)]);
    yticks([-2,0]);
end
nexttile;set(gca,'visible','off');
%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20221110_142214_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.0333_noise=400,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.3,1,1,1,0,2600,],threshold=-1,tskip=1,xskip=1,2.mat')
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
    plot([true_params(param),true_params(param)],[-10,10],':g'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks([ranges{param}(1),ranges{param}(2)]);
    yticks([-2,0]);
end

%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20221110_142214_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.0333_noise=400,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2600,],threshold=-1,tskip=1,xskip=1,2.mat')
param_names={'D_0','r','\alpha','\beta','\gamma','\eta','K'};
figure(figg);
param_inds=[1,2,7,5];
nexttile;
text(-1,0,'Richards','Interpreter','latex','FontSize',20);
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
    plot([true_params(param),true_params(param)],[-10,10],':g'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks([ranges{param}(1),ranges{param}(2)]);
    yticks([-2,0]);
end

%%
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20221110_142214_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.0333_noise=400,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2600,],threshold=-1,tskip=1,xskip=1,2.mat')
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
    plot([true_params(param),true_params(param)],[-10,10],':g'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$\log(L)$','Interpreter','latex');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks([ranges{param}(1),ranges{param}(2)]);
    yticks([-2,0]);
    else
    nexttile;
    hold on
    plot(xx,yy,'b-','DisplayName',param_names{param});
    h=plot([true_params(param),true_params(param)],[-10,10],':b'); % true max
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    h=plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--b'); % MLE
    h.Annotation.LegendInformation.IconDisplayStyle='off';
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
    h=plot([true_params(param),true_params(param)],[-10,10],':m'); % true max
    h.Annotation.LegendInformation.IconDisplayStyle='off';
    h=plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--m'); % MLE
    h.Annotation.LegendInformation.IconDisplayStyle='off';
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
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end

t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/syndata_figtable3.fig');
saveas(figg,'figure/syndata_figtable3.eps','epsc');
saveas(figg,'figure/syndata_figtable3.png');