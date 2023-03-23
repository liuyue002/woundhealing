xx=linspace(0,10,100);

figg=figure('position',[200,200,1440,250],'color','w');
t = tiledlayout(1,5);


%%
nexttile;
yy = -3*(xx-5).^2;
hold on;
plot(xx,yy);
plot([0,10],[-1.92,-1.92],'-k');
xlabel('$\theta$','interpreter','latex');
ylabel('$\log(L)$','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);
%% flat top
nexttile;

yy = -0.3*(xx-5).^2;
hold on;
plot(xx,yy);
plot([0,10],[-1.92,-1.92],'-k');
xlabel('$\theta$','interpreter','latex');
ylabel('$\log(L)$','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);

%% 
nexttile;

yy = zeros(size(xx));
yy(1:30)=-0.3*(xx(1:30)-3).^2;
yy(71:100)=-0.3*(xx(71:100)-7).^2;
hold on;
plot(xx,yy);
plot([0,10],[-1.92,-1.92],'-k');
xlabel('$\theta$','interpreter','latex');
ylabel('$\log(L)$','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);

%% infinite range
nexttile;

yy = 1./(1+exp(-xx+6)) -(xx-6).^2./(1+exp(xx))+0.6./(1+(xx-7).^2/3)-1.4;
hold on;
plot(xx,yy);
plot([0,10],[-1.92,-1.92],'-k');
xlabel('$\theta$','interpreter','latex');
ylabel('$\log(L)$','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);

%% bimodal
nexttile;
yy = -0.3*(xx-2).*(xx-3).*(xx-6).*(xx-7.1)-1.5;
hold on;
plot(xx,yy);
plot([0,10],[-1.92,-1.92],'-k');
xlabel('$\theta$','interpreter','latex');
ylabel('$\log(L)$','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);

%% 
axs=t.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 20);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end

%t.TileSpacing = 'none';
t.TileSpacing = 'tight';
t.Padding = 'none';

%%
saveas(figg,'figure/identifiability.fig');
saveas(figg,'figure/identifiability.eps','epsc');