%% set up
f = @(C,r,d,gamma,K,uk,ur) (r+ur)*C.*(1-(C./(K-uk)).^gamma)-d*C;
dfdC= @(C,r,d,gamma,K,uk,ur) (r+ur)*(1-(1+gamma)*(C./(K-uk)).^gamma)-d;
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
alphak=0.1; % weight of control cost
alphar=7e5;
uklim = 1200; %upper bound for uk
urlim = 0.8;
bangbang=false;

filename=sprintf('simulations/twomodel_control_kr_fmincon_%s_alphak=%.2f,alphar=%.2f',string(datetime,'yyyyMMdd_HHmmss'),alphak,alphar);

%% initial guess
uk=@(t) 500+rand()*50;
ur=@(t) 0.1;
tfine=linspace(0,T,upts);
uknum=arrayfun(uk,tfine);
urnum=arrayfun(ur,tfine);
uall=[uknum,urnum*1000];

%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_kr_fmincon_20230824_223710_alphak=0.10,alphar=5000000.00.mat','uall_best');
%uall=uall_best;
%load('/home/liuy1/Documents/woundhealing/expdesign/simulations/twomodel_control_k_r_d_20230825_184919_alpha=0.10,5000000.000000,100000.000000,omega=0.10.mat','uknum','urnum');
%uall=[uknum,urnum*1000];

J = @(uall) J_uk_ur(C0,T,tfine,uall(1:upts),uall(upts+1:end)/1000,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alphak,alphar,bangbang);
Jold=J(uall);

%% use fmincon to find discretized optimal control
optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',1e7,'MaxIterations',5e5,'OptimalityTolerance',1e-3,'PlotFcn',{@optimplotu,@optimplotfval,@optimplotfirstorderopt});
[uall_best,Jbest,exitflag,output,lambda,grad,hessian] = fmincon(J,uall,[],[],[],[],zeros(size(uall)),[uklim*ones(size(uknum)),urlim*1000*ones(size(urnum))],[],optimopts);
uknum_best=uall_best(1:upts);
urnum_best=uall_best(upts+1:end)/1000;

fig_opt=gcf;
%% try to find optimal control on finer grid

% tfine2=linspace(0,T,2*upts);
% uknum2=interp1(tfine,uknum,tfine2);
% J2 = @(uknum) J_uk(C0,T,tfine2,uknum,r1,d1,gamma1,K1,r2,d2,gamma2,K2,alpha,bangbang);
% optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',1000000,'PlotFcn',{@optimplotu,@optimplotfval,@optimplotfirstorderopt});
% [uknum_best2,Jbest2] = fmincon(J2,uknum2,[],[],[],[],zeros(size(uknum2)),uklim*ones(size(uknum2)),[],optimopts);

%% plot

figg=figure;
hold on;
%plot(tfine,uknum);
plot(tfine,uknum_best);
plot(tfine,urnum_best*1000);
%plot(tfine2,uknum_best2);
xlabel('t');
ylabel('u');
legend('u_k','u_r*1000');

%% save
save([filename,'.mat']);
saveas(figg,[filename,'_final.png']);
saveas(figg,[filename,'_final.eps'],'epsc');
%%


function stop = optimplotu(uall,optimValues,state,varargin)
stop = false;
global T filename
fig=gcf;
giffile=[filename,'.gif'];
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
upts=length(uall)/2;
uknum=uall(1:upts);
urnum=uall(upts+1:end);
if optimValues.iteration == 0
    hold on
    plotuk = plot(linspace(0,T,upts),uknum,'-b');
    plotur = plot(linspace(0,T,upts),urnum,'-r');
    hold off
    xlabel('t');
    set(plotuk,'Tag','optimplotuk');
    set(plotur,'Tag','optimplotur');
    legend('u_k','u_r*1000');
    ylabel('u');

    imwrite(imind,cm,giffile,'gif','DelayTime',0.5, 'Loopcount',inf);
else
    plotuk = findobj(get(gca,'Children'),'Tag','optimplotuk');
    set(plotuk,'Ydata',uknum);
    plotur = findobj(get(gca,'Children'),'Tag','optimplotur');
    set(plotur,'Ydata',urnum);
    imwrite(imind,cm,giffile,'gif','DelayTime',0.5,'WriteMode','append');
end
end

