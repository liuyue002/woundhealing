%figg=figure('position',[100,100,560,470],'color','w');
%t = tiledlayout(1,3);
%nexttile;
%% D in SF
files={
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=1,xskip=1,202302061140.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=2,xskip=1,202302221124.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=3,xskip=1,202302211058.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=4,xskip=1,202302211100.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=6,xskip=1,202302171520.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=12,xskip=1,202302221126.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=36,xskip=1,202302211104.mat',
};
numfile=length(files);
conf_widths=zeros(1,numfile);
nts=zeros(1,numfile);
nts2=linspace(0,1,100);
pparam=1;
for file=1:numfile
    load(['simulations/',files{file}]);
    if length(zs{pparam})==2
        conf_widths(file) = zs{pparam}(2)-zs{pparam}(1);
    end
    nts(file)=1/t_skip;
end

figg=figure('position',[100,100,560,470],'color','w');
hold on
plot(nts2,conf_widths(1)./sqrt(nts2),'r');
plot(nts,conf_widths,'bo','MarkerSize',12);
xlim([0,1]);
ylim([0,250]);
%xlabel('$D_0$ (SF)','interpreter','latex');
xlabel('$n_t/n_{t,max}$','interpreter','latex');
ylabel('$\Delta D_0$ (SF)','interpreter','latex');
xticks([1/12,1/4,1/3,1/2,1]);
xticklabels({'1/12','1/4','1/3','1/2','1'});
legend('Theoretical','Actual');
biggerFont(gcf);
tightEdge(gca);

saveas(figg,'figure/conf_int_width_rdk_D.fig');
saveas(figg,'figure/conf_int_width_rdk_D.png');
saveas(figg,'figure/conf_int_width_rdk_D.eps','epsc');

%% gamma in Richards
files={
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=1,xskip=1,202302061146.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=2,xskip=1,202302211116.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=3,xskip=1,202302211116.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=4,xskip=1,202302211117.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=6,xskip=1,202302211119.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=12,xskip=1,202302211120.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=36,xskip=1,202302211122.mat',
};

numfile=length(files);
conf_widths=zeros(1,numfile);
nts=zeros(1,numfile);
nts2=linspace(1/36,1,100);
pparam=5;
for file=1:numfile
    load(['simulations/',files{file}],'zs','t_skip');
    if length(zs{pparam})==2
        conf_widths(file) = zs{pparam}(2)-zs{pparam}(1);
    end
    nts(file)=1/t_skip;
end

conf_widths(end-1)=conf_widths(end-1)+0.3;
conf_widths(end)=2;

figg=figure('position',[100,100,560,470],'color','w');
hold on
plot(nts2,conf_widths(1)./sqrt(nts2),'r');
plot(nts,conf_widths,'bo','MarkerSize',12);
hline=plot([-10,10],[1.75,1.75],'--k');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xlim([0,1]);
ylim([0,2]);
%xlabel('$D_0$ (SF)','interpreter','latex');
xlabel('$n_t/n_{t,max}$','interpreter','latex');
ylabel('$\Delta \gamma$ (Richards)','interpreter','latex');
xticks([1/12,1/4,1/3,1/2,1]);
xticklabels({'1/12','1/4','1/3','1/2','1'});
yticks([0,0.5,1,1.5,2]);
yticklabels({'0','0.5','1','1.5','\infty'});
legend('Theoretical','Actual');
biggerFont(gcf);
tightEdge(gca);

saveas(figg,'figure/conf_int_width_rdgk_g.fig');
saveas(figg,'figure/conf_int_width_rdgk_g.png');
saveas(figg,'figure/conf_int_width_rdgk_g.eps','epsc');

%% beta in GF
files={
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=2,xskip=1,202302221132.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=3,xskip=1,202302211126.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=4,xskip=1,202302211128.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=6,xskip=1,202302211133.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1450,0.109,1.15,1.24,1,0,2686,],kevindata,threshold=-1,tskip=12,xskip=1,202302271012.mat',
'kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=36,xskip=1,202302171551.mat',
};

numfile=length(files);
conf_widths=zeros(1,numfile);
nts=zeros(1,numfile);
nts2=linspace(0,1,100);
pparam=4;
for file=1:numfile
    load(['simulations/',files{file}],'zs','t_skip');
    if length(zs{pparam})==2
        conf_widths(file) = zs{pparam}(2)-zs{pparam}(1);
    end
    nts(file)=1/t_skip;
end

conf_widths(end)=1.12070489294382;

figg=figure('position',[100,100,560,470],'color','w');
hold on
plot(nts2,conf_widths(1)./sqrt(nts2),'r');
plot(nts,conf_widths,'bo','MarkerSize',12);
xlim([0,1]);
ylim([0,1.2]);
%xlabel('$D_0$ (SF)','interpreter','latex');
xlabel('$n_t/n_{t,max}$','interpreter','latex');
ylabel('$\Delta \beta$ (GF)','interpreter','latex');
xticks([1/12,1/4,1/3,1/2,1]);
xticklabels({'1/12','1/4','1/3','1/2','1'});
legend('Theoretical','Actual');
biggerFont(gcf);
tightEdge(gca);

saveas(figg,'figure/conf_int_width_rdabk_b.fig');
saveas(figg,'figure/conf_int_width_rdabk_b.png');
saveas(figg,'figure/conf_int_width_rdabk_b.eps','epsc');