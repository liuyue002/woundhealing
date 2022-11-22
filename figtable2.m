figg=figure('Position',[50,50,1200,900],'color','w');
%sgtitle('xy1, 1D');
num_params=7;
ranges={[1270,1570],[0.09,0.28],[1.1,1.4],[1.1,1.4],[1.1,1.3],[0,0.1],[2610,2710]};
t = tiledlayout(4,4);
%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,1,0,],fixedparamval=[1200,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,7.mat')
figure(figg);
param_inds=[1,2,7];
for i=1:3
    param=param_inds(i);
    %subplot(4,4,i);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot(ranges{param},[-1.92,-1.92],'k-');
    xlabel(param_names{param});
    %ylabel('l');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks(ranges{param});
    yticks([-2,0]);
end
nexttile;set(gca,'visible','off');
%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,1,0,0,],fixedparamval=[1546,0.27,1,1,1,0.07,2628,],kevindata,threshold=-1,tskip=1,xskip=1,11.mat')
figure(figg);
param_inds=[1,2,7,6];
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+4);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot(ranges{param},[-1.92,-1.92],'k-');
    xlabel(param_names{param});
    %ylabel('l');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks(ranges{param});
    yticks([-2,0]);
end

%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1400,0.246,1,1,1,0,2616,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat')
figure(figg);
param_inds=[1,2,7,5];
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+8);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'b-','DisplayName',param_names{param});
    plot(ranges{param},[-1.92,-1.92],'k-');
    xlabel(param_names{param});
    %ylabel('l');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks(ranges{param});
    yticks([-2,0]);
end
xlabel('\gamma');
%%
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,0,0,1,1,0,],fixedparamval=[1423.47,0.101,1.173,1.355,1,0,2701.4,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat')
figure(figg);
param_inds=[1,2,7,3];
for i=1:4
    param=param_inds(i);
    %subplot(4,4,i+12);
    nexttile;
    hold on
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'b-');
    hline=plot(ranges{param},[-1.92,-1.92],'k-');
    hline.Annotation.LegendInformation.IconDisplayStyle='off';
    xlabel(param_names{param});
    %ylabel('l');
    axis('square');
    xlim(ranges{param});
    ylim([-2.5,0]);
    hold off;
    xticks(ranges{param});
    yticks([-2,0]);
end
%subplot(4,4,16);
param=4;
hold on
xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy,'r-');
legend('\alpha','\beta');
xlabel('');

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
saveas(figg,'figure/xy1_2d_figtable.fig');
saveas(figg,'figure/xy1_2d_figtable.png');