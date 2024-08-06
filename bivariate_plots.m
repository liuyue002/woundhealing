%% Standard Fisher model

figg=figure('Position',[50,50,1532,424],'color','w');
t = tiledlayout(1,3);
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1287,0.271,1,1,1,0,2620,],kevindata,threshold=-1,tskip=1,xskip=1,202302061140.mat','optimal_param_vals');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,1,0,],$D_0$,$r$_20240703_3.mat');
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,1,0,],$D_0$,$K$_20240703_3.mat');
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,1,0,],$r$,$K$_20240703_3.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
colorbar;

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';


%%
saveas(figg,'figure/bivariate_rdk.fig');
saveas(figg,'figure/bivariate_rdk.png');
saveas(figg,'figure/bivariate_rdk.eps','epsc');

%% Porous Fisher
figg=figure('Position',[50,50,1532,816],'color','w');
t = tiledlayout(2,3);
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,0,0,],fixedparamval=[1361,0.268,1,1,1,0.0218,2622,],kevindata,threshold=-1,tskip=1,xskip=1,202302061142.mat','optimal_param_vals');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],$D_0$,$r$_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.3f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],$D_0$,eta_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],$D_0$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],$r$,eta_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.3f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],$r$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.3f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,1,0,0,],eta,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
colorbar;

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/bivariate_rdnk.fig');
saveas(figg,'figure/bivariate_rdnk.png');
saveas(figg,'figure/bivariate_rdnk.eps','epsc');

%% Richards

figg=figure('Position',[50,50,1532,816],'color','w');
t = tiledlayout(2,3);
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,0,1,0,],fixedparamval=[1467,0.227,1,1,1.312,0,2612,],kevindata,threshold=-1,tskip=1,xskip=1,202302061146.mat','optimal_param_vals');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],$D_0$,$r$_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.3f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],$D_0$,gamma_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.1f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],$D_0$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],$r$,gamma_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.3f');
ytickformat('%.1f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],$r$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.3f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,1,1,0,1,0,],gamma,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
xtickangle(0);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(round(numpts/2)),p1s(end)]);
yticks([p2s(1),p2s(round(numpts/2)),p2s(end)]);
xtickformat('%.1f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
colorbar;

axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 22);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';
%%
saveas(figg,'figure/bivariate_rdgk.fig');
saveas(figg,'figure/bivariate_rdgk.png');
saveas(figg,'figure/bivariate_rdgk.eps','epsc');

%% gen fisher

figg=figure('Position',[50,50,1330,829],'color','w');
t = tiledlayout(3,4);
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,0,0,1,1,0,],fixedparamval=[1391,0.1429,1.1,1.2,1,0,2664,],kevindata,threshold=-1,tskip=1,xskip=1,202302161453.mat','optimal_param_vals');

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$D_0$,$r$_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$D_0$,alpha_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$D_0$,beta_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$D_0$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.0f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$r$,alpha_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$r$,beta_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],$r$,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
Z(20,7)=-11;
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],alpha,beta_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.2f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],alpha,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls,[],'all');
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,bivariate,fixed=[0,0,0,0,1,1,0,],beta,K_20240703_4.mat')
figure(figg);
nexttile;
[X,Y] = meshgrid(p1s,p2s);
Z=ls'-max(ls(1:37,:),[],'all');
Z(:,38:end)=-1000;
hold on;
con=contour(X,Y,Z,[-3,-3],'-k',LineWidth=2);
surf(X,Y,Z,'EdgeColor','none');
clim([-20,0]);
view(2);
xlim([p1s(1),p1s(end)]);
ylim([p2s(1),p2s(end)]);
axis square;
plot(optimal_param_vals(param1),optimal_param_vals(param2),'r*','MarkerSize',20);
xticks([p1s(1),p1s(end)]);
yticks([p2s(1),p2s(end)]);
xtickformat('%.2f');
ytickformat('%.0f');
param_names={'$D_0$','$r$','$\alpha$','$\beta$','$\gamma$','$\eta$','$K$'};
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");

nexttile;
ax_dummy=gca;
ax_dummy.Visible='off';
clim([-20,0]);
cb=colorbar('west');


axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 20);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';
%%
saveas(figg,'figure/bivariate_rdabk.fig');
saveas(figg,'figure/bivariate_rdabk.png');
saveas(figg,'figure/bivariate_rdabk.eps','epsc');