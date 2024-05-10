%% changing dt

load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_220644_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.067,dx=29.200,.mat','cc');
cc0=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203242_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=29.200,.mat','cc');
cc1=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203352_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.017,dx=29.200,.mat','cc');
cc2=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203650_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.008,dx=29.200,.mat','cc');
cc3=cc;
N=77*150*150;

disp(sum(abs(cc0-cc3),'all')/N);
disp(sum(abs(cc1-cc3),'all')/N);
disp(sum(abs(cc2-cc3),'all')/N);

%% changing dx

load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203242_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=29.200,.mat','cc');
cc1=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_222017_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=14.600,.mat','cc')
cc2=cc;
cc2=cc2(:,1:2:end,1:2:end);
disp(sum(abs(cc1-cc2),'all')/N);

%% changing dt, more
params=[1300,0.3,1,1,1,0,2600];

dt=1/240;
numeric_params=[25,dt,round(1/3/dt),4380, 4380, 150, 150];
[~,cc0,~] = woundhealing_2d(params,numeric_params,0,nan);

dts=[1/3,1/6,1/12,1/30,1/60,1/120];
errors=zeros(size(dts));

for i=1:size(dts,2)
    dt=dts(i);
    numeric_params=[25,dt,round(1/3/dt),4380, 4380, 150, 150];
    [~,cc1,~] = woundhealing_2d(params,numeric_params,0,nan);
    errors(i)=sum(abs(cc0-cc1),'all');
end
N=numel(cc0);
errors=errors/N;

save('figure/convergence_t.mat');
%%
figt=figure;
hold on;
plot(log(dts),log(errors),'r.',MarkerSize=35,DisplayName="Error");
ax=gca;ax.TickLabelInterpreter = 'latex';
xticks(log([1/120,1/30,1/12,1/6,1/3]));
xticklabels({'1/120','1/30','1/12','1/6','1/3'});
yticks(log([0.1,1,10,100,1000]));
yticklabels({'0.1','1','10','100','1000'});
xtickangle(0);


P = polyfit(log(dts(2:end)),log(errors(2:end)),1);
xs=-6:0.01:0;
ys=P(1)*xs+P(2);
plot(xs,ys,'b-',DisplayName="Linear fit");
legend(Location="northwest");
xlim([-5,-1]);
ylim([-2.5,7.5]);
xlabel('$\Delta t$',Interpreter="Latex");
ylabel('Error$_t(\Delta t)$',Interpreter="Latex");
biggerFont(gcf,20);
tightEdge(gca);

saveas(figt,'figure/convergence_t.fig');
saveas(figt,'figure/convergence_t.eps','epsc');

%% changing dx, more
params=[1300,0.3,1,1,1,0,2600];

nx=600;
numeric_params=[25,1/30,10,4380, 4380, nx, nx];
[~,cc0,~] = woundhealing_2d(params,numeric_params,0,nan);

nxs=[300,150,120,100,60,30];
errors=zeros(size(nxs));

for i=1:size(nxs,2)
    nx=nxs(i);
    numeric_params=[25,1/30,10,4380, 4380, nx, nx];
    [~,cc1,~] = woundhealing_2d(params,numeric_params,0,nan);
    expand_factor=round(600/nx);
    cc1_expand=zeros(size(cc0));
    for j=1:76
        cc1_expand(j,:,:)=kron(squeeze(cc1(j,:,:)),ones(expand_factor,expand_factor));
    end
    errors(i)=sum(abs(cc0-cc1_expand),'all');
end
N=numel(cc0);
errors=errors/N;
save('figure/convergence_x.mat');
%%
%errors=errors/4;
figx=figure;
ax=gca;ax.TickLabelInterpreter = 'latex';
hold on;
plot(log(1./nxs),log(errors),'r.',MarkerSize=35,DisplayName="Error");
xticks(log([1/300,1/150,1/60,1/30]));
xticklabels({'L/300','L/150','L/60','L/30'});
yticks(log([0.01,0.1,1,10,100]));
yticklabels({'0.01','0.1','1','10','100'});

P = polyfit(log(1./nxs),log(errors),1);
xs=-7:0.01:-2;
ys=P(1)*xs+P(2);
plot(xs,ys,'b-',DisplayName="Linear fit");
legend(Location="northwest");
xlim([-6,-3]);
ylim([-1,3.5]);
xlabel('$\Delta x$',Interpreter="Latex");
ylabel('Error$_x(\Delta x)$',Interpreter="Latex");
biggerFont(gcf,20);
tightEdge(gca);

saveas(figx,'figure/convergence_x.fig');
saveas(figx,'figure/convergence_x.eps','epsc');