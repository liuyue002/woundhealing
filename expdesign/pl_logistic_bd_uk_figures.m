%% fig a
addpath('/home/liuy1/Documents/woundhealing/');
figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231019_111916_sigma=20,tau0=10,tau=10,uK0=0,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    %plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202709_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_104111_sigma=20,tau0=10,tau=15,uK0=0,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202721_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_104145_sigma=20,tau0=10,tau=15,uK0=0,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202728_sigma=20,tau0=10,tau=15,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_104235_sigma=20,tau0=10,tau=15,uK0=0,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_a2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_a2.eps','epsc');

%% fig b

figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231019_113513_sigma=20,tau0=10,tau=10,uK0=50,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_122604_sigma=20,tau0=10,tau=10,uK0=50,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_145400_sigma=20,tau0=10,tau=10,uK0=50,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_122618_sigma=20,tau0=10,tau=10,uK0=50,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_123751_sigma=20,tau0=10,tau=10,uK0=50,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_122629_sigma=20,tau0=10,tau=10,uK0=50,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_123808_sigma=20,tau0=10,tau=10,uK0=50,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_b2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_b2.eps','epsc');

%% fig c


figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231018_190543_sigma=20,tau0=10,tau=10,uK0=200,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_134202_sigma=20,tau0=10,tau=10,uK0=200,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_155937_sigma=20,tau0=10,tau=10,uK0=200,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_134217_sigma=20,tau0=10,tau=10,uK0=200,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_144527_sigma=20,tau0=10,tau=10,uK0=200,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz<-30)=-40;
zz(isnan(zz))=-40;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_134228_sigma=20,tau0=10,tau=10,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_144539_sigma=20,tau0=10,tau=10,uK0=200,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_c2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_c2.eps','epsc');

%% fig d


figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231019_121900_sigma=20,tau0=10,tau=10,uK0=400,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_152217_sigma=20,tau0=10,tau=10,uK0=400,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_160043_sigma=20,tau0=10,tau=10,uK0=400,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_152229_sigma=20,tau0=10,tau=10,uK0=400,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_160102_sigma=20,tau0=10,tau=10,uK0=400,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(isnan(zz))=-Inf;
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_134228_sigma=20,tau0=10,tau=10,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_160131_sigma=20,tau0=10,tau=10,uK0=400,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_d2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_d2.eps','epsc');

%% fig e


figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231019_163057_sigma=20,tau0=0,tau=10,uK0=200,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_172511_sigma=20,tau0=0,tau=10,uK0=200,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_171910_sigma=20,tau0=0,tau=10,uK0=200,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2)+0.005,'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_172525_sigma=20,tau0=0,tau=10,uK0=200,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_171923_sigma=20,tau0=0,tau=10,uK0=200,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(isnan(zz))=-Inf;
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_172532_sigma=20,tau0=0,tau=10,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_171943_sigma=20,tau0=0,tau=10,uK0=200,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_e2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_e2.eps','epsc');

%% fig f


figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231019_180548_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_183357_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_182500_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_183410_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_182515_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(isnan(zz))=-Inf;
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_183421_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_182536_sigma=20,tau0=10,tau=2.5,uK0=200,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_f2.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_f2.eps','epsc');


%% fig g


figg=figure('Position',[100,100,1800,300]);
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_usingode45/pl_logistic_bd_uk_20231020_134413_sigma=20,tau0=10,tau=15,uK0=200,rng=0.mat');
figure(figg);
param_names={'$r$','$\delta$','$\gamma$','$K$'};
positions=[[0.05           0.2116         0.1         0.7133],
           [0.21           0.2116         0.1         0.7133],
           [0.37           0.2116         0.1         0.7133],
           [0.53           0.2116         0.1         0.7133],
           [0.69           0.2116         0.1         0.7133],
           [0.85           0.2116         0.1         0.7133],
           [0.90           0.2116         0.01         0.7133]];
xlims=[[0,1],
       [0,1],
       [0,1],
       [0,10000]];
%tl=tiledlayout(1,6);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    %nexttile;
    ax=axes(figg,"innerposition",positions(free_param_count,:));
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim(xlims(param,:));
    ylim([-2.5,0]);
    if param == 1 || param == 2
        xtickformat('%.1f');
    end
    ytickformat('%.1f');
    xticks(xlims(param,:));
    yticks([-2.5,0]);
    xtickangle(0);
    hold off;
end

ax=axes(figg,"innerposition",positions(4,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202709_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,delta.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_195519_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,delta.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(5,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202721_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_195529_sigma=20,tau0=10,tau=15,uK0=200,rng=0,r,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(isnan(zz))=-Inf;
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(6,:));
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240317_202728_sigma=20,tau0=10,tau=15,uK0=200,rng=0,delta,K.mat');
load('/home/liuy1/Documents/woundhealing/expdesign/simulations/pl_logistic_bd_uk_bivariate_20240403_195547_sigma=20,tau0=10,tau=15,uK0=200,rng=0,delta,K.mat');
figure(figg);
%imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
[p1mesh,p2mesh]=meshgrid(p1s,p2s);
zz=ls'-max(ls,[],'all');
zz(isnan(zz))=-Inf;
zz(zz==-Inf)=min(zz(zz~=-Inf),[],'all')-1000;
surf(p1mesh,p2mesh,zz,'LineStyle','none');
view(0,90);
clim([-20,0]);
xlim([p1s(1),p1s(numpts)]);
ylim([p2s(2),p2s(numpts)]);
axis('square');
%colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
yl=ylabel(param_names{param2},Interpreter="latex");
yl.Position(1)=-0.1;
xticks([p1s(1),p1s(numpts)]);
yticks([p2s(1),p2s(numpts)]);

hold on
plot(true_params(param1),true_params(param2),'r*','MarkerSize',20);
plot(optimal_param_vals(param1),optimal_param_vals(param2),'g*','MarkerSize',20);

ax=axes(figg,"innerposition",positions(7,:));
c = colorbar;
clim([-20,0]);
c.Ticks=[-20,0];
c.Position=[0.963104325699745 0.268211920529801 0.01 0.599337748344371];
ax.Visible = 'off';

biggerFont(figg,18);

saveas(figg,'figure/pl_logistic_bd_uk_fig_g.fig');
saveas(figg,'figure/pl_logistic_bd_uk_fig_g.eps','epsc');