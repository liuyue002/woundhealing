%% D in Std Fisher 

figg=figure('color','w');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=1,xskip=1,202302061140.mat')
figure(figg);
hold on;
param=1;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'b-','DisplayName','$n_t=77$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=4,xskip=1,202302211100.mat')
figure(figg);
hold on;
param=1;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'m-','DisplayName','$n_t=20$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=36,xskip=1,202302211104.mat')
figure(figg);
hold on;
param=1;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'r-','DisplayName','$n_t=3$');

hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xlim([1100,1450]);
ylim([-2.5,0]);
xlabel('$D_0$ (SF)','Interpreter','latex');
ylabel('$\log(L)$','Interpreter','latex');
legend('Interpreter','latex');
%title('$D_0$ in SF','Interpreter','latex');

biggerFont(gcf,22);
tightEdge(gca);

saveas(figg,'figure/lowdata_pl_compare_rDk_D.fig');
saveas(figg,'figure/lowdata_pl_compare_rDk_D.eps','epsc');

%% gamma in richards

figg=figure('color','w');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=1,xskip=1,202302061146.mat')
figure(figg);
hold on;
param=5;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'b-','DisplayName','$n_t=77$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=4,xskip=1,202302211117.mat')
figure(figg);
hold on;
param=5;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'m-','DisplayName','$n_t=20$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=36,xskip=1,202302211122.mat')
figure(figg);
hold on;
param=5;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'r-','DisplayName','$n_t=3$');

hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xlim([1,7]);
xticks([1,3,5,7]);
ylim([-2.5,0]);
xlabel('$\gamma$ (Richards)','Interpreter','latex');
ylabel('$\log(L)$','Interpreter','latex');
legend('Interpreter','latex');
%title('$D_0$ in SF','Interpreter','latex');

biggerFont(gcf,22);
tightEdge(gca);

saveas(figg,'figure/lowdata_pl_compare_rDgk_g.fig');
saveas(figg,'figure/lowdata_pl_compare_rDgk_g.eps','epsc');

%% beta in GF

figg=figure('color','w');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat')
figure(figg);
hold on;
param=4;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'b-','DisplayName','$n_t=77$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=4,xskip=1,202302211128.mat')
figure(figg);
hold on;
param=4;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'m-','DisplayName','$n_t=20$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=36,xskip=1,202302171551.mat')
figure(figg);
hold on;
param=4;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
xx=[.28,0.34,0.41,xx];
yy=[-2.8,-0.6,-0.3,yy];
plot(xx,yy,'r-','DisplayName','$n_t=3$');

hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xlim([0.3,2]);
xticks([0.5,1,1.5,2]);
ylim([-2.5,0]);
xlabel('$\beta$ (GF)','Interpreter','latex');
ylabel('$\log(L)$','Interpreter','latex');
legend('Interpreter','latex');
%title('$D_0$ in SF','Interpreter','latex');

biggerFont(gcf,22);
tightEdge(gca);

saveas(figg,'figure/lowdata_pl_compare_rDabk_b.fig');
saveas(figg,'figure/lowdata_pl_compare_rDabk_b.eps','epsc');


%% r in GF


figg=figure('color','w');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat')
figure(figg);
hold on;
param=2;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'b-','DisplayName','$n_t=77$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=4,xskip=1,202302211128.mat')
figure(figg);
hold on;
param=2;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'m-','DisplayName','$n_t=20$');
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,lowdata,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.143,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=36,xskip=1,202302171551.mat')
figure(figg);
hold on;
param=2;
xx=param_vals(param,:);
yy=max_ls(param,:)-max(max_ls(param,:));
plot(xx,yy,'r-','DisplayName','$n_t=3$');

hline=plot([-1e6,1e6],[-1.92,-1.92],'k-');
hline.Annotation.LegendInformation.IconDisplayStyle='off';
xlim([0.05,0.2]);
xticks([0.5,1,1.5,2]);
ylim([-2.5,0]);
legend('Interpreter','latex');
%title('$D_0$ in SF','Interpreter','latex');

biggerFont(gcf,22);
tightEdge(gca);

%saveas(figg,'figure/lowdata_pl_compare_rDabk_r.fig');
%saveas(figg,'figure/lowdata_pl_compare_rDabk_r.eps','epsc');
