k=1;
%r=1;
c0=0.1;

c2 = @(t,r) k*c0./(c0 + (k-c0).*exp(-r.*t));

ts=linspace(0,8,40);
ts2=linspace(0,8,10);

fig=figure;
hold on
plot(ts,c2(ts,0.3),'DisplayName','r=0.4');
plot(ts,c2(ts,0.7),'DisplayName','r=0.7');
plot(ts,c2(ts,1.1),'DisplayName','r=1.0');
plot(ts2,abs(c2(ts2,0.7) + normrnd(0,0.07,1,10)),'b*','DisplayName','Data');
hold off
xlabel('t');
ylabel('C(t)');
xlim([0,8]);
ylim([0,1.1]);
legend('Location','northwest');
biggerFont(gcf);

%%
xx=linspace(0.15,0.3,20);
fig2=figure;
hold on
plot(xx,-1500*(xx-0.22).^2);
plot([0,1],[-1.92,-1.92],'-k');
xlim([0.15,0.3]);
ylim([-2.5,0]);
xlabel('\theta');
ylabel('log(p)');
biggerFont(gcf);

yy2=-1500*(xx-0.22).^2;
yy2=[-5.35000000000000,-3.78559556786704,-1.40817174515236,-1.21772853185596,-0.81426592797784,-0.49778393351801,-0.28282548476454,-0.10761772853186,-0.0,-0.02166204986149582,-0.080083102493075,-0.625484764542936,-0.387867036011079,-0.15722991689751,-0.0857340720222,-0.14689750692521,-0.35720221606648,-1.08448753462604,-2.49875346260388,-3.60000000000000]
fig3=figure;
hold on
plot(xx,yy2);
plot([0,1],[-1.92,-1.92],'-k');
xlim([0.15,0.3]);
ylim([-2.5,0]);
xlabel('\theta');
ylabel('log(p)');
biggerFont(gcf);

%% std fisher comparison bw circular experiment replicates (1d)
files={
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2640,],kevindata,threshold=-1,tskip=1,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy2_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1300,0.3,1,1,1,0,2640,],kevindata,threshold=-1,tskip=1,xskip=1,2.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy5_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1500,0.3,1,1,1,0,2600,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy6_20220405_raw_radial1D,weighted,fixed=[0,0,1,1,1,1,0,],fixedparamval=[1280,0.277,1,1,1,0,2885,],kevindata,threshold=-1,tskip=1,xskip=1,3.mat',
    };
colors={'r','g','b','m'};
fig4=figure('Position',[100 100 1400 400],'color','w');
freeparams=[1,2,7];

for fi=1:4
    load(files{fi});
    figure(fig4);
    for parami=1:3
        subplot(1,3,parami);
        param=freeparams(parami);
        hold on;
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        plot(xx,yy,colors{fi});
        plot([0,4000],[-1.92,-1.92],'k');
        xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    %xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    end
end
subplot(1,3,1);
xlim([800,2000]);
subplot(1,3,2);
xlim([0.2,0.4]);
subplot(1,3,3);
xlim([2300,3000]);
biggerFont(gcf);

%% richards comparison bw circular experiment replicates (2d)
files={
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1400,0.246,1,1,1,0,2616,],kevindata,threshold=-1,tskip=1,xskip=1,10.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy2_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[916.817,0.406174,1,1,0.630784,0,2561.23,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy5_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1293,0.26,1,1,1,0,2514,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy6_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[1565,0.21,1,1,1.64,0,2774,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
    };
colors={'r','g','b','m'};
fig5=figure('Position',[100 100 1400 400],'color','w');
freeparams=[1,2,5,7];

for fi=1:4
    load(files{fi});
    param_names{5}='\gamma';
    figure(fig5);
    for parami=1:4
        subplot(1,4,parami);
        param=freeparams(parami);
        hold on;
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        plot(xx,yy,colors{fi});
        plot([0,4000],[-1.92,-1.92],'k');
        xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    %xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    end
end
subplot(1,4,1);
xlim([800,2000]);
subplot(1,4,2);
xlim([0.15,0.5]);
subplot(1,4,3);
xlim([0,2]);
subplot(1,4,4);
xlim([2300,3000]);

subplot(1,4,1);
ax=gca;
ax.Children(8).YData(1)=-2.6;
ax.Children(8).YData(end)=-2.6;

subplot(1,4,4);
ax=gca;
ax.Children(2).YData(1)=-2.6;
ax.Children(2).YData(end)=-2.6;
biggerFont(gcf);

%% richards comparison bw triangular experiment replicates (2d)
files={
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy3_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2697.13,0.136,1,1,7.805,0,2335.76,],kevindata,threshold=-1,tskip=1,xskip=1,15.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy4_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2290,0.14,1,1,8.1,0,2287,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy7_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[3179.77,0.1057,1,1,8.9999,0,2353.07,],kevindata,threshold=-1,tskip=1,xskip=1,5.mat',
    '/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy8_20220405_raw_fixed=[0,0,1,1,0,1,0,],fixedparamval=[2666,0.12,1,1,8.9,0,2240,],kevindata,threshold=-1,tskip=1,xskip=1,4.mat',
    };
colors={'r','g','b','m'};
fig5=figure('Position',[100 100 1400 400],'color','w');
freeparams=[1,2,5,7];

for fi=1:4
    load(files{fi});
    figure(fig5);
    for parami=1:4
        subplot(1,4,parami);
        param=freeparams(parami);
        hold on;
        xx=param_vals(param,:);
        yy=max_ls(param,:)-max(max_ls(param,:));
        plot(xx,yy,colors{fi});
        plot([0,4000],[-1.92,-1.92],'k');
        xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    %xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    hold off;
    end
end
subplot(1,4,1);
xlim([2000,3500]);
subplot(1,4,2);
xlim([0.08,0.15]);
subplot(1,4,3);
xlim([7,9]);
subplot(1,4,4);
xlim([2200,2400]);

biggerFont(gcf);

%% data gif
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_circle_xy1_20220405_raw.mat');
circle_data=noisy_data;
load('/home/liuy1/Documents/woundhealing/simulations/kevindata_triangle_xy3_20220405_raw.mat');
triangle_data=noisy_data;
crange=[0,4000];
fig_pos = [100 100 1080 500];
figgif=figure('Position',fig_pos,'color','w');
sfig1=subplot('Position',[0,0.01,0.4,0.98]);
circfig=imagesc(squeeze(circle_data(1,:,:)),crange);
set(gca,'YDir','normal');
colormap('hot');
%colorbar;
axis image;
set(sfig1,'XTick',[]);
set(sfig1,'YTick',[]);
set(sfig1,'XTickLabel',[]);
set(sfig1,'YTickLabel',[]);
sfig2=subplot('Position',[0.45,0.01,0.45,0.98]);
trigfig=imagesc(squeeze(triangle_data(1,:,:)),crange);
set(gca,'YDir','normal');
colormap('hot');
colorbar('eastoutside','TickLabels',crange,'Ticks',crange);
axis image;
set(sfig2,'XTick',[]);
set(sfig2,'YTick',[]);
set(sfig2,'XTickLabel',[]);
set(sfig2,'YTickLabel',[]);
tit=sgtitle('t=0');
biggerFont(gcf);

giffile='figure/data/data_movie.gif';

nt=size(circle_data,1);
for i=1:nt
    circfig.CData=squeeze(circle_data(i,:,:));
    trigfig.CData=squeeze(triangle_data(i,:,:));
    tit.String=sprintf('t=%.1f',(i-1)/3);
    drawnow;
    frame = getframe(figgif);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    saveas(figgif,sprintf('figure/data/data_%.2d.png',i));
    if i==1
        imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,giffile,'gif','WriteMode','append','DelayTime',0);
    end
end

%%
figg=figure('Position',[100,100,600,500],'color','w');
xx=linspace(0,10,11);
yy = -0.2*(xx-5).^2;
hold on;
plot(xx,yy,'-*','MarkerEdgeColor','r','MarkerSize',13);
plot([0,10],[-1.92,-1.92],'-k');
%annotation('textarrow',[5,6],[0,0.2],'String','MLE');
%annotation('textarrow',[7,8],[-0.8,-0.6],'String','aaa');
ylabel('$\log(L)$','interpreter','latex');
xlabel('$\theta$','interpreter','latex');
ylabel('Log profile likelihood','interpreter','latex');
xlim([0,10]);
ylim([-2.5,0]);
yticks([-2,-1,0]);
xticks([0,5,10]);
ax=gca;
biggerFont(gcf);
