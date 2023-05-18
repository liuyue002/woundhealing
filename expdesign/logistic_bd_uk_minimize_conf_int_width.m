

%% the default controls
u_K0=200;
tau0=5;
tau=10;
%% do some plot first
u_K0s=linspace(50,800,10);
ff=@(u_K0) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_uK0=arrayfun(ff,u_K0s);

fig1=figure;
plot(u_K0s,widths_uK0);
xlabel('u_K0');
ylabel('r range');

tau0s=linspace(0,25,41);
ff=@(tau0) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_tau0=arrayfun(ff,tau0s);

fig2=figure;
plot(tau0s,widths_tau0);
xlabel('tau0');
ylabel('r range');

taus=linspace(0,20,41);
ff=@(tau) logistic_bd_uk_rrange(u_K0,tau0,tau);
widths_tau=arrayfun(ff,taus);

fig3=figure;
plot(taus,widths_tau);
xlabel('tau');
ylabel('r range');

%% do a 2D plot

tau0ss=linspace(0,25,21);
tauss=linspace(0,25,21);
[X,Y]=meshgrid(tau0ss,tauss);
Z=arrayfun(@(tau0,tau)logistic_bd_uk_rrange(u_K0,tau0,tau), X,Y);
fig4=figure;
surf(X,Y,Z);
xlabel('tau0');
ylabel('tau');
zlabel('r range');
view(0,90);
colorbar;
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
save('logistic_bd_uk_minimize_conf_int_width.mat','-mat');