% params = [p1, p2, p3, p4, V]
params=[0.03, 0.1, 10 , 0.3];
g=1;
ic=[g,0];
T=240;
nt=60;
u1=@(t) (t<100)*1;
%u1=@(t) 0;
u2=@(t) (t>50)*(t<150)*5;
%u2=@(t) 0;
numeric_params={T,nt,u1,u2};

opt=odeset('MaxStep',0.5);
ode = @(t,X) [-params(1)*X(1)-params(2)*X(2)+u1(t);
              -params(3)*X(2)+params(4)*X(1)+u2(t)];
[tt,X] = ode45(ode,[0,T],ic,opt);

t=linspace(0,T,nt);
sol = interp1(tt,X,t);
clean_data=sol(:,1);
noisy_data=sol(:,1)+2*randn(size(sol(:,1)));
figure;
hold on;
plot(t,sol(:,1)*1,DisplayName="G");
plot(t,sol(:,2)*10,DisplayName="I*10");
plot(t,noisy_data,DisplayName="noisy");
legend();

figtitle=sprintf('glucose_bolie_%s_control12_',string(datetime,'yyyyMMdd_HHmmss'));

%% MLE
fixed=[0,0,0,0];
fixed_param_val=params;
lb_opt=[0,0,0,0];
ub_opt=[1,10,500,10];
opt.lb=lb_opt;
opt.ub=ub_opt;
opt.logging=true;
opt.alg=2;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@glucose_err,fixed_param_val,fixed,noisy_data,numeric_params,ic,opt);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;
%%
mle_sol = glucose_model(optimal_param_vals,numeric_params,ic);
mle_sol = mle_sol(:,1);
figure;
hold on;
plot(t,clean_data,DisplayName="clean data");
plot(t,noisy_data,DisplayName="noisy data");
plot(t,mle_sol,DisplayName="MLE solution");
legend();

%% profile likelihood

fixed_param_val=params;
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
lb=[ 0,0,0,0];
ub=[0.1, 1, 100 , 3];
opt.alg=2;
param_names={'$p_1$','$p_2$','$p_3$','$p_4$'};

numpts=41;
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
    % for i=mle_idx+1:numpts+1
    %     fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
    %     %initial(fixed_params==0)=minimizers{param,i-1};
    %     initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
    %     initial(param)=param_vals(param,i);
    %     [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@glucose_err,initial,fixed_params,noisy_data,numeric_params,ic,opt);
    %     %[minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,initial,fixed_params,noisy_data,numeric_params,C0,opt);
    %     minimizers{param,i}=minimizer;
    %     %save([prefix,'_',figtitle,'.mat'],'-mat');
    % end
    % for i=mle_idx-1:-1:1
    %     fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
    %     %initial(fixed_params==0)=minimizers{param,i+1};
    %     initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
    %     initial(param)=param_vals(param,i);
    %     [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@glucose_err,initial,fixed_params,noisy_data,numeric_params,ic,opt);
    %     %[minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,initial,fixed_params,noisy_data,numeric_params,C0,opt);
    %     minimizers{param,i}=minimizer;
    %     %save([prefix,'_',figtitle,'.mat'],'-mat');
    % end

    for i=1:1:numpts+1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=optimal_param_vals(fixed_params==0);
        initial(param)=param_vals(param,i);
        if param==2 && fixed(4)==0 % build-in guess for non-identifiable params
            initial(4)=params(2)*params(4)/initial(2);
        end
        if param==4 && fixed(2)==0
            initial(2)=params(2)*params(4)/initial(4);
        end
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@glucose_err,initial,fixed_params,noisy_data,numeric_params,ic,opt);
        %[minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_ctrl_sq_err_bangbang,initial,fixed_params,noisy_data,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

%% plot profile likelihood
true_params=params;
fig=figure('Position',[100 100 1200 400],'color','w');
tl=tiledlayout(1,num_free_params);
%sgtitle(sprintf('$u_{max}=%.0f,\\tau_0=%.0f,\\tau=%.0f$',u_K0,tau0,tau),'interpreter','latex','fontSize',30);
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
    % ytickformat('%.1f');
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


%%
i=12;
param=2;
params2=params;params2(param)=param_vals(param,i);params2(logical([1,0,1,1]))=minimizers{param,i};
sol2 = glucose_model(params2,numeric_params,ic);
sol2=sol2(:,1);
figure;
hold on
plot(t,sol2,DisplayName='another fitted model');
plot(t,noisy_data,DisplayName='noisy data');

disp(glucose_err(noisy_data,params,numeric_params,ic,0));
disp(glucose_err(noisy_data,params2,numeric_params,ic,0));

%% save
prefix='/home/liuy1/Documents/woundhealing/expdesign/simulations/';
save([prefix,figtitle,'.mat'],'-mat');
saveas(fig,[prefix,figtitle,'.png']);
saveas(fig,[prefix,figtitle,'.eps'],'epsc');
%%
function [err] = glucose_err(data,params,numeric_params,ic,logging)
model_data = glucose_model(params,numeric_params,ic);

err=sum((model_data(:,1)-data).^2,'all');

err=err*1000; % hack to get the optimisation to go for lower tolerance

if logging
    fprintf(['params=',repmat('%.3f,',size(params)),'sum_sq_error=%.6f\n'],params,err);
end
end

function sol = glucose_model(params,numeric_params,ic)
T=numeric_params{1};
nt=numeric_params{2};
u1=numeric_params{3};
u2=numeric_params{4};
t=linspace(0,T,nt);
opt=odeset('MaxStep',0.5);
ode = @(t,X) [-params(1)*X(1)-params(2)*X(2)+u1(t);
              -params(3)*X(2)+params(4)*X(1)+u2(t)];
[tt,X] = ode45(ode,[0,T],ic,opt);
sol = interp1(tt,X,t);
end