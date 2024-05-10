%% generate data
addpath('/home/liuy1/Documents/woundhealing/expdesign');
seed=0;
rng(seed);
C0=100;
nt=101;
T=25;
t=linspace(0,T,nt);
params=[0.45,0.15,1,3900];
%params=[0.225,0,8,2381];
u_K0=200; %%%%
tau0=10; %%%%
tau=15; %%%%
u_d=@(t)0;
u_r=@(t)0;
u_K=@(t) ((t>tau0)&(t<(tau0+tau)))*u_K0;
clean_data=sol_richards_control(t,params,C0,u_d,u_K,u_r);
%clean_data=sol_richards_bangbang2(t,params,C0,0,0,0,0,0,0,u_K0,tau0,tau0+tau);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

param1=2; param2=4;% which 2 params to loop over... 1/2, 1/4, 2/4
param_names={'r','delta','gamma','K'};

figtitle=sprintf('pl_logistic_bd_uk_bivariate_%s_sigma=%g,tau0=%g,tau=%g,uK0=%g,rng=%g,%s,%s',string(datetime,'yyyyMMdd_HHmmss'),sigma,tau0,tau,u_K0,seed,param_names{param1},param_names{param2});
prefix='/home/liuy1/Documents/woundhealing/expdesign/simulations/';
logfile = [prefix,figtitle,'_log.txt'];
diary(logfile);
fprintf('Started: %s\n',string(datetime('now'),'yyyyMMdd_HHmmSS'));

%% MLE
fixed=[0,0,1,0];
fixed_param_val=params;
numeric_params={T,nt,u_d,u_K,u_r};
%numeric_params=[T,nt,0,0,0,0,0,0,u_K0,tau0,tau0+tau];
lb_opt=[0,0,0,0];
ub_opt=[5,5,9,50000];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=1;
% [mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
% %[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
% optimal_param_vals=fixed_param_val';
% optimal_param_vals(fixed==0)=mle;
% 
% mle_soln=sol_richards_control(t,optimal_param_vals,C0,u_d,u_K,u_r);

%% profile likelihood for logistic, with birth/death, and u_K
% bivariate between r/delta, r/k, delta/k

numpts=201;
lb=[0, 0, 1, 0]; 
ub=[1, 1, 1, 10000];
param_names={'$r$','$\delta$','$\gamma$','$K$'};
fixed_params=fixed;
fixed_params(param1)=1;
fixed_params(param2)=1;
num_free_params=sum(1-fixed);
p1s=linspace(lb(param1),ub(param1),numpts);
p2s=linspace(lb(param2),ub(param2),numpts);
ls=zeros(numpts,numpts);
minimizers=cell(numpts,numpts);

for i=1:numpts
    for j=1:numpts
        initial=fixed_param_val;
        initial(param1)=p1s(i);
        initial(param2)=p2s(j);
        shortcut=0;
        % if I know the likelihod is very small, skip the calculation
        if param1==1 && param2==2
            if abs(initial(param2)-(initial(param1)-0.3))>0.03
                shortcut=1;
            end
        end
        if param1==1 && param2==4
            if abs(initial(param2)-8666.66*initial(param1))>500
                shortcut=1;
            end
        end
        if param1==2 && param2==4
            if abs(initial(param2)-(8666.66*initial(param1)+2600))>500
                shortcut=1;
            end
        end
        if shortcut
            fprintf('shortcut for %s=%.3f,%s=%.3f\n',param_names{param1},initial(param1),param_names{param2},initial(param2));
            ls(i,j)=-Inf;
        else
            fprintf('Optimizing for %s=%.3f,%s=%.3f\n',param_names{param1},initial(param1),param_names{param2},initial(param2));
            if num_free_params==0
                % not doing this case
            else
                % optimize over parameters other than r and D
                [minimizer,~,ls(i,j)] = optimize_likelihood_general(@richards_ctrl_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
                initial(fixed==0)=minimizer;
                minimizers{i,j}=initial;
            end
        end
    end
end

%% plot

fig=figure;
imagesc(ls'-max(ls,[],'all'),[-20,0]); % need transpose + reverse axis to make it right
colorbar;
set(gca,'YDir','normal');
xlabel(param_names{param1},Interpreter="latex");
ylabel(param_names{param2},Interpreter="latex");
set(gca,'XTick',[1,round(numpts/2),numpts]);
set(gca,'XTickLabel',num2str([p1s(1),p1s(ceil(numpts/2)),p1s(numpts)]','%.3f'));
set(gca,'YTick',[1,round(numpts/2),numpts]);
set(gca,'YTickLabel',num2str([p2s(1),p2s(ceil(numpts/2)),p2s(numpts)]','%.3f'));

[~,I] = max(ls',[],'all','linear');
[ix, iy] = ind2sub(size(ls'),I);
hold on
plot(iy,ix,'r*','MarkerSize',20);

%% save
save([prefix,figtitle,'.mat'],'-mat');
saveas(fig,[prefix,figtitle,'.png']);
saveas(fig,[prefix,figtitle,'.fig']);
saveas(fig,[prefix,figtitle,'.eps'],'epsc');
fprintf('finish run on: %s\n',string(datetime('now'),'yyyyMMdd_HHmmSS'));
diary off;
