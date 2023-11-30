%% set up
f = @(C,r,d,gamma,K,uk) r*C.*(1-(C./(K-uk)).^gamma)-d*C;
dfdC= @(C,r,d,gamma,K,uk) r*(1-(1+gamma)*(C./(K-uk)).^gamma)-d;
%dfduk= @(C,r,d,gamma,K,uk) -r*gamma*(C./(K-uk)).^(gamma+1);
global T filename;

r1=0.45;
d1=0.15;
gamma1=1;
K1=3900;

r2=0.3;
d2=0;
gamma2=1;
K2=2600;

C0=100;
T=25;
upts=100;
alpha=0.03; % weight of control cost
omega=0.1; % control update rate
uklim = 1200; %upper bound for uk
bangbang=false;

filename=sprintf('simulations/twomodel_control_fmincon_%s_alpha=%.2f,omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),alpha,omega);

%% initialise
uk=@(t) 100;
tfine=linspace(0,T,upts);
uknum=arrayfun(uk,tfine);
load('simulations/twomodel_control_20230627_174137_alpha=0.03,omega=0.10.mat','uknum');

J = @(uknum) J_uk(C0,T,tfine,uknum,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha,bangbang);
Jold=J(uknum);

%% use fmincon to find discretized optimal control
optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',100000,'PlotFcn',{@optimplotu,@optimplotfval,@optimplotfirstorderopt});
[uknum_best,Jbest] = fmincon(J,uknum,[],[],[],[],zeros(size(uknum)),uklim*ones(size(uknum)),[],optimopts);


%% try to find optimal control on finer grid

% tfine2=linspace(0,T,2*upts);
% uknum2=interp1(tfine,uknum,tfine2);
% J2 = @(uknum) J_uk(C0,T,tfine2,uknum,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha,bangbang);
% optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',1000000,'PlotFcn',{@optimplotu,@optimplotfval,@optimplotfirstorderopt});
% [uknum_best2,Jbest2] = fmincon(J2,uknum2,[],[],[],[],zeros(size(uknum2)),uklim*ones(size(uknum2)),[],optimopts);

%% plot

figg=figure;
hold on;
plot(tfine,uknum);
plot(tfine,uknum_best);
%plot(tfine2,uknum_best2);
xlabel('t');
ylabel('u');
legend('FW-BW sweep','fmincon fine');

%% save
save([filename,'.mat']);

%%


function stop = optimplotu(u,optimValues,state,varargin)
stop = false;
global T filename
fig=gcf;
giffile=[filename,'.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if optimValues.iteration == 0
    plotu = plot(linspace(0,T,length(u)),u);
    xlabel('t');
    set(plotu,'Tag','optimplotu');
    ylabel('u');

    imwrite(imind,cm,giffile,'gif','DelayTime',0.5, 'Loopcount',inf);
else
    plotu = findobj(get(gca,'Children'),'Tag','optimplotu');
    set(plotu,'Ydata',u);
    imwrite(imind,cm,giffile,'gif','DelayTime',0.5,'WriteMode','append');
end
end

