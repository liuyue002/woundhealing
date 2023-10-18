% make some profile likelhiood figures for paper/thesis

%% logistic
figg=figure('Position',[50,50,920,900],'color','w');
num_params=2;
param_inds=[1,4];
param_names={'r','K'};
t = tiledlayout(3,5);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/logistic_rrange_vs_initial_C0=1_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=1$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:2
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0.2,0.6];
    elseif i==2
        xrange=[100,10000];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/logistic_rrange_vs_initial_C0=100_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=100$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:2
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0.2,0.6];
    elseif i==2
        xrange=[1000,7000];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/logistic_rrange_vs_initial_C0=2300_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=2300$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:2
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0,1];
    elseif i==2
        xrange=[1000,7000];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/fig_pl_logistic_init.fig');
saveas(figg,'figure/fig_pl_logistic_init.png');
saveas(figg,'figure/fig_pl_logistic_init.eps','epsc');

%% richards
figg=figure('Position',[50,50,1300,900],'color','w');
num_params=3;
param_inds=[1,3,4];
param_names={'r','K'};
t = tiledlayout(3,7);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/richards_rrange_vs_initial_C0=1_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=1$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
optimal_param_vals(3)=0.1;
for i=1:3
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0,1.6];
    elseif i==2
        xrange=[0,9];
    elseif i==3
        xrange=[0,10000];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/richards_rrange_vs_initial_C0=100_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=100$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:3
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0.10,0.30];
    elseif i==2
        xrange=[0,9];
    elseif i==3
        xrange=[2100,2700];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/richards_rrange_vs_initial_C0=2300_2.mat');
figure(figg);
nexttile;
text(-1,0,{'$C_0=2300$'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;
for i=1:3
    param=param_inds(i);
    nexttile([1,2]);
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot([-1e6,1e6],[-1.92,-1.92],'k-');
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true param
    xlabel(['$',param_names{param},'$'],'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xrange=[min(xx),max(xx)];
    if i==1
        xrange=[0,2];
    elseif i==2
        xrange=[0,9];
    elseif i==3
        xrange=[0,10000];
    end
    %xrange=[round(optimal_param_vals(param)-range_width(param)/2,4,'significant'),round(optimal_param_vals(param)+range_width(param)/2,4,'significant')];
    %xrange=ranges{param};
    xlim(xrange);
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    ylim([-2.5,0]);
    hold off;
    yticks([-2,0]);
    xtickangle(0);
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';
%%
saveas(figg,'figure/fig_pl_richards_init.fig');
saveas(figg,'figure/fig_pl_richards_init.png');
saveas(figg,'figure/fig_pl_richards_init.eps','epsc');

%%
function fmt = getxticklabelFormat(strs)
% given the current xticklabels, find the right format so all numbers have
% consistent number of sigfigs
mostsigfig=0;
for i=1:length(strs)
    decimalpt=strfind(strs{i},'.');
    if isempty(decimalpt)
        sigfig=0;
    else
        sigfig=length(strs{i})-decimalpt;
    end
    mostsigfig = max(mostsigfig,sigfig);
end
fmt=['%.',num2str(mostsigfig),'f'];
end