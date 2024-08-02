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

%% threethings, ua
figg=figure('Position',[50,50,850,250],'color','w');
param_inds=[7,8,9];
t = tiledlayout(1,3);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/threethings,202407271613,_2threethings,10  20   2   0   0   0   0   0   0,_2.mat');
param_names={0,0,0,0,0,0,'$c_1$','$c_2$','$c_3$'};
figure(figg);
for param=param_inds
    nexttile;
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    if param==8
        yy(28)=0;
        yy(31)=0;
        yy(34)=0;
    end
    if param==9
        xx=xx([1:3,5:end]);
        yy=yy([1:3,5:end]);
    end

    if param==7
        xrange=[0,0.6];
    elseif param==8
        xrange=[0,6];
    elseif param==9
        xrange=[0,6];
    end
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    xlim(xrange);
    plot(xx,yy);
    plot(xrange,[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},Interpreter="latex");
    ylabel('$l$',Interpreter="latex");
    axis('square');
    ylim([-2.5,0]);
    ytickformat('%.1f');
    yticks([-2.5,0]);
    hold off;
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/fig_pl_threethings_ua.fig');
saveas(figg,'figure/fig_pl_threethings_ua.png');
saveas(figg,'figure/fig_pl_threethings_ua.eps','epsc');

%% threethings, ub
figg=figure('Position',[50,50,850,250],'color','w');
param_inds=[7,8,9];
t = tiledlayout(1,3);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/threethings,202407271841,_4threethings,0   0   0  10  20  18   0   0   0,_4.mat');
param_names={0,0,0,0,0,0,'$c_1$','$c_2$','$c_3$'};
figure(figg);
for param=param_inds
    nexttile;
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    if param==7
        xx=xx([1:25,27:end]);
        yy=yy([1:25,27:end]);
    end

    if param==7
        xrange=[0,0.6];
    elseif param==8
        xrange=[0,0.6];
    elseif param==9
        xrange=[0,1.5];
    end
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    xlim(xrange);
    plot(xx,yy);
    plot(xrange,[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},Interpreter="latex");
    ylabel('$l$',Interpreter="latex");
    axis('square');
    ylim([-2.5,0]);
    ytickformat('%.1f');
    yticks([-2.5,0]);
    hold off;
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/fig_pl_threethings_ub.fig');
saveas(figg,'figure/fig_pl_threethings_ub.png');
saveas(figg,'figure/fig_pl_threethings_ub.eps','epsc');

%% threethings, uc
figg=figure('Position',[50,50,850,250],'color','w');
param_inds=[7,8,9];
t = tiledlayout(1,3);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/threethings,202407271706,_3threethings,0   0   0   0   0   0  10  20  18,_3.mat');
param_names={0,0,0,0,0,0,'$c_1$','$c_2$','$c_3$'};
figure(figg);
for param=param_inds
    nexttile;
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if param==7
        xrange=[0,0.6];
    elseif param==8
        xrange=[0,6];
    elseif param==9
        xrange=[0.9,1.1];
    end
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    xlim(xrange);
    plot(xx,yy);
    plot(xrange,[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},Interpreter="latex");
    ylabel('$l$',Interpreter="latex");
    axis('square');
    ylim([-2.5,0]);
    ytickformat('%.1f');
    yticks([-2.5,0]);
    hold off;
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/fig_pl_threethings_uc.fig');
saveas(figg,'figure/fig_pl_threethings_uc.png');
saveas(figg,'figure/fig_pl_threethings_uc.eps','epsc');

%% threethings, no control
figg=figure('Position',[50,50,850,250],'color','w');
param_inds=[7,8,9];
t = tiledlayout(1,3);

load('/home/liuy1/Documents/woundhealing/expdesign/simulations/threethings,202407271651,_3threethings,0  0  0  0  0  0  0  0  0,_3.mat');
param_names={0,0,0,0,0,0,'$c_1$','$c_2$','$c_3$'};
figure(figg);
for param=param_inds
    nexttile;
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));

    if param==7
        xrange=[0,0.6];
    elseif param==8
        xrange=[0,6];
    elseif param==9
        xrange=[0,6];
    end
    xticks(xrange);
    xtickformat(getxticklabelFormat(xticklabels));
    xlim(xrange);
    plot(xx,yy);
    plot(xrange,[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},Interpreter="latex");
    ylabel('$l$',Interpreter="latex");
    axis('square');
    ylim([-2.5,0]);
    ytickformat('%.1f');
    yticks([-2.5,0]);
    hold off;
end

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/fig_pl_threethings_nocontrol.fig');
saveas(figg,'figure/fig_pl_threethings_nocontrol.png');
saveas(figg,'figure/fig_pl_threethings_nocontrol.eps','epsc');

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