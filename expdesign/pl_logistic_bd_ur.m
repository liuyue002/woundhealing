%% generate data
addpath('/home/liuy1/Documents/woundhealing/');
seed=0;
rng(seed);
C0=100;
nt=101;
T=25;
t=linspace(0,T,nt);
params=[0.45,0.15,1,3900];
%params=[0.225,0,8,2381];
urmax=0.02;
tau0=10;
tau=10;
u_d=@(t)0;
u_K=@(t)0;
u_r=@(t) ((t>tau0)&(t<(tau0+tau)))*urmax;
clean_data=sol_richards_control(t,params,C0,u_d,u_K,u_r);
%clean_data=sol_richards_bangbang2(t,params,C0,0,0,0,0,0,0,u_K0,tau0,tau0+tau);
sigma=20;
noisy_data=clean_data+randn(size(clean_data))*sigma;

%data2=sol_richards_control(t,[0.2302,0.0803,1,2000],C0,u_d,u_K);

solfig=figure;
hold on
plot(t,clean_data);
plot(t,noisy_data);
plot(t,u_K(t));
%plot(t,data2);

figtitle=sprintf('pl_logistic_bd_ur_%s_sigma=%g,tau0=%g,tau=%g,urmax=%g,rng=%g',string(datetime,'yyyyMMdd_HHmmss'),sigma,tau0,tau,urmax,seed);
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
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
%[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,fixed_param_val,fixed,noisy_data,numeric_params,C0,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

mle_soln=sol_richards_control(t,optimal_param_vals,C0,u_d,u_K,u_r);

% get something close to true value

%% profile likelihood for logistic, with birth/death, and u_K

fixed_param_val=params;
%fixed=[0,0,1,0];
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
lb=[ 0.10, 0.00, 7,  1000];
ub=[ 1.00, 1.00, 9, 10000];
opt.ub=[10,10,10,99000];
opt.alg=1;
param_names={'$r$','$\delta$','$\gamma$','$K$'};

numpts=11;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
minimizers=cell(num_params,numpts);
% add the global optimum to the list of param vals
param_vals=[param_vals,optimal_param_vals];

for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,1:numpts)=linspace(lb(param),ub(param),numpts);
    param_vals(param,:)=sort(param_vals(param,:));
    [~,mle_idx]=min(abs(param_vals(param,:)-optimal_param_vals(param)));
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=fixed_param_val;
    minimizers{param,mle_idx}=optimal_param_vals(fixed_params==0);
    max_ls(param,mle_idx)=max_l;
    for i=mle_idx+1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i-1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        %[minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        %[minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
true_params=params;
fig=figure('Position',[100 100 1200 400],'color','w');
tl=tiledlayout(1,num_free_params);
sgtitle(sprintf('$u_{max}=%.2f,\\tau_0=%.0f,\\tau=%.0f$',urmax,tau0,tau),'interpreter','latex','fontSize',30);
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    %subplot(1,num_free_params,free_param_count);
    nexttile;
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([0,1e10],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param},'Interpreter','latex');
    ylabel('$l$','Interpreter','latex');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
    % if param == 1 || param == 2
    %     xtickformat('%.1f');
    % end
    ytickformat('%.1f');
    hold off;

    zs{param}=interp_zero(xx,yy+1.92);
    if size(zs{param},2) == 2
        conf_interval(param)=zs{param}(2)-zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [%.4f,%.4f]\n',conf_interval(param),zs{param}(1),zs{param}(2));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'n')
        conf_interval(param)=zs{param}(1);
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=%.4f: [0,%.4f]\n',conf_interval(param),zs{param}(1));
    elseif size(zs{param},2) == 1 && strcmp(param_names{param},'gamma')
        conf_interval(param)=Inf;
        fprintf('95%% Confidence interval for param %s is: (intercept at -1.92)\n',param_names{param});
        fprintf('width=Inf: [%.4f,Inf]\n',zs{param}(1));
    else
        fprintf('Do not have 2 intercepts for param %s, they are:\n',param_names{param});
        disp(zs{param});
    end
end
betterFig(fig);
%error('stop the execution');
%% find lower edge of conf int of r (accurately with bisection)
% so this is a more accurate version of zs{1}
% r_eff=params(1)-params(2);
% bd_rlow=[0.001,optimal_param_vals(1)];
% opt.logging=false;
% plr=@(r) plr_helper(r,params,noisy_data,numeric_params,C0,opt,max_l) + 1.92;
% [r_lower,fval,exitflag,output] = fzero(plr,bd_rlow);
% fprintf('r_lower=%.4f\n',r_lower);
% 
% 
% if length(zs{1})<2
%     % we didn't find an upper bound for the confidence interval of r
%     r_upper=Inf;
% else
%     bd_rhigh=[optimal_param_vals(1),ub(1)];
%     [r_upper,fval,exitflag,output] = fzero(plr,bd_rhigh);
%     fprintf('r_upper=%.4f\n',r_upper);
% end
% 
% r_conf_range=r_upper-r_lower;
% fprintf('r_conf_range=%.4f\n',r_conf_range);

%% save
prefix='/home/liuy1/Documents/woundhealing/expdesign/simulations/';
save([prefix,figtitle,'.mat'],'-mat');
%biggerFont(fig);
saveas(fig,[prefix,figtitle,'.png']);
saveas(fig,[prefix,figtitle,'.eps'],'epsc');

%% better fig
% betterFig(fig);
% % fig.Children.Title.FontSize=30;
% axes(fig.Children.Children(3));
% xtickformat('%.1f');
% ytickformat('%.1f');
% xlim([0,1]);
% ylim([-2.5,0]);
% yticks([-2.5,-2.0,-1.5,-1.0,-0.5,0]);
% axes(fig.Children.Children(2));
% xtickformat('%.1f');
% ytickformat('%.1f');
% xlim([0,1]);
% ylim([-2.5,0]);
% yticks([-2.5,-2.0,-1.5,-1.0,-0.5,0]);
% axes(fig.Children.Children(1));
% xtickformat('%d');
% ytickformat('%.1f');
% xlim([0,10000]);
% ylim([-2.5,0]);
% yticks([-2.5,-2.0,-1.5,-1.0,-0.5,0]);
% xticks(xlim);
% 
% sgtitle('');
% saveas(fig,[figtitle,'.eps'],'epsc');
%%
function pl = plr_helper(r,params,noisy_data,numeric_params,C0,opt,max_l)
    [~,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err,[r,params(2),params(3),params(4)],[1,0,1,0],noisy_data,numeric_params,C0,opt);
    %[~,~,max_l2]=optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,[r,params(2),params(3),params(4)],[1,0,1,0],noisy_data,numeric_params,C0,opt);
    pl=max_l2-max_l;
end

