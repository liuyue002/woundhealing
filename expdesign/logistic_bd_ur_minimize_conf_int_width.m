

%% the default controls
urmax=0.02;
tau0=10;
tau=10;
filename='logistic_bd_ur_minimize_conf_int_width_6';
diary([filename,'_log.txt']);
warning('off','MATLAB:ode45:IntegrationTolNotMet');
%% do some plot first
urs=linspace(0.001,0.2,101);
ff=@(u_K0) logistic_bd_ur_rrange(u_K0,tau0,tau);
widths_uK0=arrayfun(ff,urs);

tau0s=linspace(0,15,101);
ff=@(tau0) logistic_bd_ur_rrange(urmax,tau0,tau);
widths_tau0=arrayfun(ff,tau0s);

taus=linspace(0,15,101);
ff=@(tau) logistic_bd_ur_rrange(urmax,tau0,tau);
widths_tau=arrayfun(ff,taus);

fig1=figure;
plot(urs,widths_uK0);
xlim([0,0.2]);
ylim([0,2]);
yticks(0:2);
xticks(0:0.1:0.2);
xlabel('$u_{max}$','Interpreter','latex');
ylabel('$\Delta r$','Interpreter','latex');
betterFig(fig1);
saveas(fig1,['figure/',filename,'_umax.eps'],'epsc');

fig2=figure;
plot(tau0s,widths_tau0);
xlim([0,15]);
ylim([0,4]);
yticks(0:4);
xlabel('$\tau_0$','Interpreter','latex');
ylabel('$\Delta r$','Interpreter','latex');
betterFig(fig2);
saveas(fig2,['figure/',filename,'_tau0.eps'],'epsc');

fig3=figure;
plot(taus,widths_tau);
xlim([0,15]);
ylim([0,3]);
yticks(0:3);
xlabel('$\tau$','Interpreter','latex');
ylabel('$\Delta r$','Interpreter','latex');
betterFig(fig3);
saveas(fig3,['figure/',filename,'_tau.eps'],'epsc');

%% do a 2D plot

tau0ss=linspace(0,25,41);
tauss=linspace(1,25,41);
[X,Y]=meshgrid(tau0ss,tauss);
Z=arrayfun(@(tau0,tau)logistic_bd_ur_rrange(urmax,tau0,tau), X,Y);
fig4=figure;
surf(X,Y,Z,'LineStyle','none');
xlabel('tau0');
ylabel('tau');
zlabel('r range');
clim([0,2]);
view(0,90);
colorbar;
title('rrange vs tau,tau0');

%% do a 2D plot for model difference
C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
params1=[0.45,0.15,1,3900];
params2=[0.3,0,1,2600];
modeldiff_fn=@(tau0,tau) sum(sol_richards_control(t,params1,C0,@(t)0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*urmax) - ...
                             sol_richards_control(t,params2,C0,@(t)0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*urmax),'all');

modeldiffs=arrayfun(modeldiff_fn, X,Y);
fig5=figure;
surf(X,Y,modeldiffs,'LineStyle','none');
xlabel('tau0');
ylabel('tau');
zlabel('model diff');
view(0,90);
colorbar;
title('model diff');

fig6=figure;
surf(X,Y,modeldiffs./Y,'LineStyle','none');
xlabel('tau0');
ylabel('tau');
zlabel('model diff/tau');
view(0,90);
colorbar;
title('model diff/tau');
%%

% tau0=5;
% tau=20;
% model1soln=sol_richards_control(t,params1,C0,@(t)0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*urmax);
% model2soln=sol_richards_control(t,params2,C0,@(t)0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*urmax);
% u_K=((t>tau0)&(t<(tau0+tau)))*u_K0;
% figure;
% hold on
% plot(t,model1soln);
% plot(t,model2soln);
% plot(t,u_K);
%% optimize

options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
%options.ScaleProblem=true;
problem.objective=@(x)logistic_bd_ur_rrange(urmax,x(1),x(2));
problem.x0=[15,10];
problem.solver='fmincon';
problem.lb=[0,0];
problem.ub=[25,25];
problem.options=options;
[minimizer,min_rrange,exitflag,fmincon_output] = fmincon(problem);
disp(minimizer);
%%
save([filename,'.mat'],'-mat');
diary off;