figg=figure('Position',[50,50,1200,900],'color','w');
%sgtitle('xy1, 1D');
num_params=7;
t = tiledlayout(4,5);
t_skips=[1,2,3,4,12,36];
nts=[77,39,26,20,7,3];
numfiles=6;
colors={'r','g','b','c','m','y'};

sf_files={
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=1,xskip=1,202302061140.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=2,xskip=1,202302221124.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=3,xskip=1,202302211058.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=4,xskip=1,202302211100.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=12,xskip=1,202302221126.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=36,xskip=1,202302211104.mat',
    };

pf_files={
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.0218,2622,],kevindata,threshold=-1,tskip=1,xskip=1,202302061142.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.022,2622,],kevindata,threshold=-1,tskip=2,xskip=1,202302211107.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.022,2622,],kevindata,threshold=-1,tskip=3,xskip=1,202302171527.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.022,2622,],kevindata,threshold=-1,tskip=4,xskip=1,202302211108.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.022,2622,],kevindata,threshold=-1,tskip=12,xskip=1,202302211110.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.022,2622,],kevindata,threshold=-1,tskip=36,xskip=1,202302211112.mat',
    };

richards_files={
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=1,xskip=1,202302061146.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=2,xskip=1,202302211116.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=3,xskip=1,202302211116.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=4,xskip=1,202302211117.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=12,xskip=1,202302211120.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=36,xskip=1,202302211122.mat',
    };

gf_files={
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=2,xskip=1,202302221132.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=3,xskip=1,202302211126.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=4,xskip=1,202302211128.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1450,0.109,1.15,1.24,1,0,2686,],kevindata,threshold=-1,tskip=12,xskip=1,202302271012.mat',
    'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=36,xskip=1,202302171551.mat',
    };

%% SF
nexttile;
text(-1,0,{'Standard','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;

ax=nexttile;
for file=1:numfiles
    load(['simulations/',sf_files{file}]);
    close(fig);
    param=1;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
axes(ax);
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[1100,1450];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$D_0$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',sf_files{file}]);
    close(fig);
    param=2;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0.24,0.29];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2.5,-2,-1.5,-1,-0.5,0]);
ytickformat('%.1f');
xlabel('$r$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',sf_files{file}]);
    close(fig);
    param=7;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    if file==6
        xx=xx-55;
    end
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[2600,2680];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$K$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

nexttile;
hold on;
for file=1:numfiles
    plot(0,0,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
legend('Interpreter','latex');
axis off;

%% PF

nexttile;
text(-1,0,{'Porous','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;

ax=nexttile;
for file=1:numfiles
    load(['simulations/',pf_files{file}]);
    close(fig);
    param=1;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
axes(ax);
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[1100,1750];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$D_0$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',pf_files{file}]);
    close(fig);
    param=2;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0.23,0.29];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2.5,-2,-1.5,-1,-0.5,0]);
ytickformat('%.1f');
xlabel('$r$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',pf_files{file}]);
    close(fig);
    param=7;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    if file==6
        xx=xx-55;
    end
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[2600,2700];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2.5,-2,-1.5,-1,-0.5,0]);
ytickformat('%.1f');
xlabel('$K$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',pf_files{file}]);
    close(fig);
    param=6;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0,0.15];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2.5,-2,-1.5,-1,-0.5,0]);
ytickformat('%.1f');
xtickformat('%.2f');
xlabel('$\eta$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

%% Richards

nexttile;
text(-1,0,{'Richards'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;

ax=nexttile;
for file=1:numfiles
    load(['simulations/',richards_files{file}]);
    close(fig);
    param=1;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
axes(ax);
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[1000,3000];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$D_0$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',richards_files{file}]);
    close(fig);
    param=2;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0.1,0.3];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$r$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',richards_files{file}]);
    close(fig);
    param=7;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    if file==6
        xx=xx-55;
    end
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[2550,2650];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2.5,-2,-1.5,-1,-0.5,0]);
ytickformat('%.1f');
xlabel('$K$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',richards_files{file}]);
    close(fig);
    param=5;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[1,7];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$\gamma$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

%% GF

nexttile;
text(-1,0,{'Generalised','Fisher'},'Interpreter','latex','FontSize',20);
axis([-1,1,-1,1]);
axis off;

ax=nexttile;
for file=1:numfiles
    load(['simulations/',gf_files{file}]);
    close(fig);
    param=1;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
axes(ax);
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[1100,2400];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$D_0$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',gf_files{file}]);
    close(fig);
    param=2;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0.0,0.3];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xtickformat('%.1f');
xlabel('$r$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',gf_files{file}]);
    close(fig);
    param=7;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    if file==6
        xx=xx-55;
    end
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[2550,2750];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xlabel('$K$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

ax=nexttile;
for file=1:numfiles
    load(['simulations/',gf_files{file}]);
    close(fig);
    param=4;
    axes(ax);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    % if file==numfiles
    %     yy(18)=(yy(17)+yy(19))/2;
    %     yy(24)=(yy(23)+yy(25))/2;
    %     yy(31)=(yy(30)+yy(32))/2;
    % end
    plot(xx,yy,colors{file},'DisplayName',sprintf('$n_t=%d$',nts(file)));
end
hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xrange=[0.5,2];
xlim(xrange);
xticks(xrange);
ylim([-2.5,0]);
yticks([-2,-1,0]);
ytickformat('%.1f');
xtickformat('%.1f');
xlabel('$\beta$','Interpreter','latex');
ylabel('$l$','Interpreter','latex');

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
saveas(figg,'figure/lowdata_pl_all.fig');
saveas(figg,'figure/lowdata_pl_all.png');
saveas(figg,'figure/lowdata_pl_all.eps','epsc');