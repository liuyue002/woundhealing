

%% the default controls
u_K0=200;
tau0=5;
tau=10;
filename='logistic_bd_uk_minimize_conf_int_width_4';
diary([filename,'_log.txt']);
warning('off','MATLAB:ode45:IntegrationTolNotMet');
%% do some plot first
u_K0s=linspace(50,800,101);
ff=@(u_K0) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_uK0=arrayfun(ff,u_K0s);

fig1=figure;
plot(u_K0s,widths_uK0);
xlim([50,800]);
xlabel('u_K0');
ylabel('r range');

tau0s=linspace(0,25,101);
ff=@(tau0) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_tau0=arrayfun(ff,tau0s);

fig2=figure;
plot(tau0s,widths_tau0);
xlim([0,25]);
xlabel('tau0');
ylabel('r range');

taus=linspace(0,20,101);
ff=@(tau) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_tau=arrayfun(ff,taus);

fig3=figure;
plot(taus,widths_tau);
xlim([0,20]);
xlabel('tau');
ylabel('r range');

%% do a 2D plot

tau0ss=linspace(0,25,41);
tauss=linspace(0,25,41);
[X,Y]=meshgrid(tau0ss,tauss);
Z=arrayfun(@(tau0,tau)logistic_bd_uk_rrange(u_K0,tau0,tau), X,Y);
fig4=figure;
surf(X,Y,Z,'LineStyle','none');
xlabel('tau0');
ylabel('tau');
zlabel('r range');
view(0,90);
colorbar;

%% do a 2D plot for model difference
C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
params1=[0.45,0.15,1,3900];
params2=[0.3,0,1,2600];
modeldiff_fn=@(tau0,tau) sum(sol_richards_control(t,params1,C0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*u_K0) - ...
                             sol_richards_control(t,params2,C0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*u_K0),'all');

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

tau0=5;
tau=20;
model1soln=sol_richards_control(t,params1,C0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*u_K0);
model2soln=sol_richards_control(t,params2,C0,@(t)0,@(t)((t>tau0)&(t<(tau0+tau)))*u_K0);
u_K=((t>tau0)&(t<(tau0+tau)))*u_K0;
figure;
hold on
plot(t,model1soln);
plot(t,model2soln);
plot(t,u_K);
%% optimize

options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
options.Diagnostics='on';
options.MaxFunctionEvaluations=6000;
%options.ScaleProblem=true;
problem.objective=@(x)logistic_bd_uk_rrange(200,x(1),x(2));
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