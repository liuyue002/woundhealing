%% general setup
% whether the effects of the control variables are absolute (additive) or
% relative (multiplicative)
absolute = true;
alpha = [5e5, 5e5, 4];

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

% initial guess
urmax=0;tau0r=0;tau1r=0;
udmax=0;tau0d=0;tau1d=0;
ukmax=1300;tau0k=5;tau1k=10;
% [urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k, ]
control_params_init = [urmax,tau0r,tau1r, ...
                       udmax,tau0d,tau1d, ...
                       ukmax,tau0k,tau1k];
param_scaling = [1,1,1, ...
                 1,1,1, ...
                 1000,1,1];
fixed_params = [1,1,1, ...
                1,1,1, ...
                1,0,0]; % which params are kept fixed during the optimisation
lb = [0,0,0,   0,0,0,   0,0,0];
ub = [1,T,T,   1,T,T,   1300,T,T];


filename=sprintf('simulations/twomodel_control_bangbang_gen_%s_fixed=[%d%d%d%d%d%d%d%d%d],alpha=[%.2f,%.2f,%.2f]',string(datetime,'yyyyMMdd_HHmmss'),fixed_params,alpha);
makeplot=true;
giffile=[filename,'.gif'];
logfile=[filename,'.txt'];
matfile=[filename,'.mat'];
if makeplot
    diary(logfile);
end
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));

%% optimise the window functions

num_params=length(control_params_init);
param_str='[';
paramcount=1;
for i=1:num_params
    if ~fixed_params(i)
            param_str=sprintf('%s x(%d)*param_scaling(%d),',param_str,paramcount,i);
            paramcount = paramcount+1;
    else
        param_str=sprintf('%s control_params_init(%d),',param_str,i);
    end
end
param_str=strcat(param_str,']');
f_str=sprintf('f=@(x) objective_gen([r1,d1,gamma1,K1],[r2,d2,gamma2,K2],T,C0,absolute,%s,alpha);',param_str);
eval(f_str);

optimopts=optimoptions('fmincon','Display','iter-detailed','MaxFunctionEvaluations',1000,'PlotFcn',{@optimplotfval,@optimplotfirstorderopt});
[x_best,cost_best] = fmincon(f,control_params_init(fixed_params==0),[],[],[],[],lb(fixed_params==0),ub(fixed_params==0),[],optimopts);
%%%%% to do: implement nonlinear constraint that tau0<tau1

%% plot
figure;
hold on;
control_params_best = control_params_init;
control_params_best(fixed_params==0) = x_best;
[t1,sol1] = sol_richards_bangbang(T,[r1,d1,gamma1,K1],absolute,control_params_best,C0);
[t2,sol2] = sol_richards_bangbang(T,[r2,d2,gamma2,K2],absolute,control_params_best,C0);
plot(t1,sol1,'DisplayName','C_1');
plot(t2,sol2,'DisplayName','C_2');
window = @(t,max,tau0,tau1) max*(t>tau0).*(t<tau1);
urfun = @(t) window(t,control_params_best(1),control_params_best(2),control_params_best(3));
udfun = @(t) window(t,control_params_best(4),control_params_best(5),control_params_best(6));
ukfun = @(t) window(t,control_params_best(7),control_params_best(8),control_params_best(9));
plot(t1,urfun(t1),'DisplayName','u_r');
plot(t1,udfun(t1),'DisplayName','u_d');
plot(t1,ukfun(t1),'DisplayName','u_k');
hold off;
legend;

xlabel('t');
%% save

%% helper functions
function cost = objective_gen(model_params1,model_params2,T,C0,control_abs,control_params,alpha)

costur = alpha(1)*control_params(1)*(control_params(3)-control_params(2));
costud = alpha(2)*control_params(4)*(control_params(6)-control_params(5));
costuk = alpha(3)*control_params(7)*(control_params(9)-control_params(8));

[t1,sol1] = sol_richards_bangbang(T,model_params1,control_abs,control_params,C0);
[t2,sol2] = sol_richards_bangbang(T,model_params2,control_abs,control_params,C0);
t=linspace(0,T,200);
sol1 = interp1(t1,sol1,t);
sol2 = interp1(t2,sol2,t);
costmodel = -trapz(t,(sol1-sol2).^2);

costu = costur + costud + costuk;
cost = costu + costmodel;
fprintf('Control params: xxx , costu: %.5f, costmodel %.5f, costtotal: %.5f:\n',costu, costmodel, cost);
end
