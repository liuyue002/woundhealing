%% general setup
% whether the effects of the control variables are absolute (additive) or
% relative (multiplicative)
absolute = false;

% uall=[ur,ud,uk];
if absolute
    % effects of u's are additivie
    fgen = @(C,r,d,gamma,K,uall) (r+uall(1))*C.*(1-(C./(K-uall(3))).^gamma)-(d+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) (r+uall(1))*(1-(1+gamma)*(C./(K-uall(3))).^gamma)-(d+uall(2));
    % lower/upper bound for control variables
    lb = [0,0,0];
    ub = [0.5, 0.5, 1200];
    % weight of control cost
    alpha = [3e4, 3e4, 0.03];
    plotting_scale=[1000,1000,1];
    default_u = [0.1, 0.05, 700]; %starting point of optimisation
else
    % effects of u's are multiplicative
    fgen = @(C,r,d,gamma,K,uall) r*(1+uall(1))*C.*(1-(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) r*(1+uall(1))*(1-(1+gamma)*(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2));
    % lower/upper bound for control variables
    lb = [0,0,0];
    ub = [0.5, 0.5, 0.5];
    % weight of control cost
    alpha = [1.3e6, 1.3e6, 3e4];
    plotting_scale=[1000,1000,1000];
    default_u = [0, 0, 0.1]; %starting point of optimisation
end

r1=0.225;
d1=0;
gamma1=8;
K1=2381;

r2=0.235;
d2=0;
gamma2=3;
K2=2433;

global T filename active_u
active_u=logical([false, false, true]); % ud, ud, uk
% initial guess
ur=@(t) 0;
ud=@(t) 0;
uk=@(t) 0.4;

C0=100;
T=25;
upts=100;
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/upts);
omega=0.1;

filename=sprintf('simulations/twomodel_control_gen_fmincon_richard_%s_absolute=%d_active=[%d,%d,%d],alpha=[%.2f,%.2f,%.2f],omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),absolute,active_u,alpha,omega);
makeplot=true;
giffile=[filename,'.gif'];
logfile=[filename,'.txt'];
matfile=[filename,'.mat'];
if makeplot
    diary(logfile);
end
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));

%% initialise
ts=linspace(0,T,upts);
%unum=arrayfun(ud,ts);
load('simulations/twomodel_control_gen_richard_20230914_005907_active=[0,0,1],absolute=0,alpha=[130000.00,130000.00,30000.00],omega=0.10.mat','unum');
unum=unum(active_u,1:end);

J = @(unum) Jgen(C0,T,ts,unum,fgen,dfdCgen,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha);

%% use fmincon to find discretized optimal control
% for now only support one u active at a time
optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',100000,'PlotFcn',{@optimplotu,@optimplotfval,@optimplotfirstorderopt});
[unum_best,Jbest] = fmincon(J,unum,[],[],[],[],zeros(size(unum)),ub(active_u)*ones(size(unum)),[],optimopts);

%% plot

figg=figure;
hold on;
plot(ts,unum);
plot(ts,unum_best);
%plot(tfine2,uknum_best2);
xlabel('t');
ylabel('u');
legend('FW-BW sweep','fmincon');

%% save
saveas(figg,[filename,'.png']);
save([filename,'.mat']);

%% helper functions
function uallnum = inflate_u(unum)
global active_u
uallnum=zeros(3,size(unum,2));
uallnum(active_u,1:end)=unum;
end

function [J,Jcontrol,Jmodel,C,Lambda] = Jgen(C0,T,ts,unum,fgen,dfdCgen,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha)
global active_u
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/100);
Lambinit=[0;0];
uallnum=zeros(3,size(ts,2));
uallnum(active_u,1:end)=unum;
uall = @(t) [interp1(ts,uallnum(1,:),t),...
             interp1(ts,uallnum(2,:),t),...
             interp1(ts,uallnum(3,:),t)];
%forward
odefunC=@(t,C) [fgen(C(1),r1,d1,gamma1,K1,uall(t));
                fgen(C(2),r2,d2,gamma2,K2,uall(t))];
[t,X]=ode45(odefunC,[0,T],[C0;C0],odeopts);

%backward
C1fun=@(tt)interp1(t,X(:,1),tt)';
C2fun=@(tt)interp1(t,X(:,2),tt)';
odefunLamb=@(t,lambdas) [-2*(C1fun(t)-C2fun(t))-lambdas(1)*dfdCgen(C1fun(t),r1,d1,gamma1,K1,uall(t));
                         +2*(C1fun(t)-C2fun(t))-lambdas(2)*dfdCgen(C2fun(t),r2,d2,gamma2,K2,uall(t));];
[t2,Lamb]=ode45(odefunLamb,[T,0],Lambinit,odeopts);
%reverse the time
t2=flipud(t2);
Lamb=flipud(Lamb);

%calculate J (want to minimize J)
Jcontrol=alpha*trapz(ts,uallnum.^2,2);
Jmodel=trapz(t,-(X(:,1)-X(:,2)).^2);
J=Jmodel + Jcontrol;

nt=length(ts);
C=zeros(nt,2);
C(:,1)=interp1(t,X(:,1),ts);
C(:,2)=interp1(t,X(:,2),ts);
Lambda=zeros(nt,2);
Lambda(:,1)=interp1(t2,Lamb(:,1),ts);
Lambda(:,2)=interp1(t2,Lamb(:,2),ts);
end

function stop = optimplotu(unum,optimValues,state,varargin)
stop = false;
global T filename active_u
nt=size(unum,2);
uallnum=inflate_u(unum);
fig=gcf;
giffile=[filename,'.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if optimValues.iteration == 0
    hold on;
    plotur = plot(linspace(0,T,nt),uallnum(1,1:end));
    plotud = plot(linspace(0,T,nt),uallnum(2,1:end));
    plotuk = plot(linspace(0,T,nt),uallnum(3,1:end));
    hold off;
    xlabel('t');
    set(plotur,'Tag','optimplotur');
    set(plotud,'Tag','optimplotud');
    set(plotuk,'Tag','optimplotuk');
    ylabel('u');

    imwrite(imind,cm,giffile,'gif','DelayTime',0.5, 'Loopcount',inf);
else
    plotur = findobj(get(gca,'Children'),'Tag','optimplotur');
    set(plotur,'Ydata',uallnum(1,1:end));
    plotud = findobj(get(gca,'Children'),'Tag','optimplotud');
    set(plotud,'Ydata',uallnum(2,1:end));
    plotuk = findobj(get(gca,'Children'),'Tag','optimplotuk');
    set(plotuk,'Ydata',uallnum(3,1:end));
    imwrite(imind,cm,giffile,'gif','DelayTime',0.5,'WriteMode','append');
end
end