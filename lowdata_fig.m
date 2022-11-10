figg=figure('Position',[100 100 1400 400],'color','w');
%sgtitle('low data comparison, xy1');
num_params=7;
%%

% rDk model
% files={
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2640,],kevindata,threshold=-1,tskip=1,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],kevindata,threshold=-1,tskip=2,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],kevindata,threshold=-1,tskip=3,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],kevindata,threshold=-1,tskip=6,xskip=1,3.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],kevindata,threshold=-1,tskip=12,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.27,1,1,1,0,2650,],kevindata,threshold=-1,tskip=36,xskip=1,2.mat',
%     };

% rDnk model
% files={
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1336,0.266,1,1,1,0.01,2647,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.27,1,1,1,0.01,2650,],kevindata,threshold=-1,tskip=2,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.27,1,1,1,0.01,2650,],kevindata,threshold=-1,tskip=3,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.27,1,1,1,0.01,2650,],kevindata,threshold=-1,tskip=6,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.27,1,1,1,0.01,2650,],kevindata,threshold=-1,tskip=12,xskip=1,2.mat',
%     '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1300,0.27,1,1,1,0.01,2650,],kevindata,threshold=-1,tskip=36,xskip=1,2.mat',
%     };

% rDgk model
files={
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2640,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1850,0.17,1,1,2.26,0,2615,],kevindata,threshold=-1,tskip=2,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1850,0.17,1,1,2.26,0,2615,],kevindata,threshold=-1,tskip=3,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1850,0.17,1,1,2.26,0,2615,],kevindata,threshold=-1,tskip=6,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1850,0.17,1,1,2.26,0,2615,],kevindata,threshold=-1,tskip=12,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1850,0.17,1,1,2.26,0,2615,],kevindata,threshold=-1,tskip=36,xskip=1,2.mat',
    };

%%
num_files=length(files);
tskips=zeros(num_files,1);
conf_interval_width=nan(num_params,num_files);

for f=1:num_files
    load(files{f});
    param_names{5}='\gamma';
    tskips(f)=t_skip;
    figure(figg);
    free_param_count=0;
    for param=1:num_params
        if fixed(param)
            continue;
        end
        free_param_count = free_param_count+1;
        subplot(1,num_free_params,free_param_count);
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        hold on;
        plot(xx,yy,'DisplayName',num2str(ceil(nt/t_skip)),'Color',[1,1-f/num_files,0.0]);
        h=plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.92,-1.92],'-k');
        h.Annotation.LegendInformation.IconDisplayStyle = 'off'; % no legend
        xlabel(param_names{param});
        ylabel('log(L)');
        axis('square');
        xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
        ylim([-2.5,0]);
        conf_interval_width(param,f)=conf_interval(param);
    end
end

%%
% figure(figg);
% subplot(1,4,1);
% xlim([1600,3000]);
% ylim([-2.5,0]);
% subplot(1,4,2);
% xlim([0.1,0.2]);
% ylim([-2.5,0]);
% subplot(1,4,3);
% xlim([1.5,5]);
% ylim([-2.5,0]);
% subplot(1,4,4);
% xlim([2570,2720]);
% ylim([-2.5,0]);
% % legend('1','2','3','6','12','36');
% legend();
%legend('Location','eastoutside');
biggerFont(gcf);

%%
figg_conf_int=figure('Position',[100 100 1400 400],'color','w');
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on
    %plot(1./tskips,conf_interval_width(param,:),'*b','Markersize',20);
    %xx=linspace(1/36,1,50);
    %plot(xx,conf_interval_width(param,1)./sqrt(xx));
    
    nts=ceil(nt./tskips);
    xx=linspace(1,80,80);
    plot(nts,conf_interval_width(param,:),'*b','Markersize',20);
    plot(xx,conf_interval_width(param,1)./sqrt(xx/nt));
    xlim([0,80]);
    xticks(flip(nts));
    hold off
    title(param_names{param});
    %xlabel('Proportion of data used');
    xlabel('n_t');
    ylabel('Confidence interval width');
end
legend('actual','predicted');
%%
prefix='simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],';
saveas(figg,[prefix,'_overlay.png']);
saveas(figg_conf_int,[prefix,'_conf_interval_width_2.png']);
saveas(figg_conf_int,[prefix,'_conf_interval_width_2.fig']);