% look at exactsoln.m

r=0.225;
d=0;
g=8;
k=2380;
true_params=[r,d,g,k];
T=25;
nt=51; % use fewer points to illustrate reduce in identifiability
C0=2300; % vary this


%% do a profile likelihood with C0=100
filename=sprintf('simulations/logistic_rrange_vs_initial_C0=%g_3',C0);
diary([filename,'.txt']);
fprintf('Doing C0=%f\n',C0);

tt=linspace(0,T,nt);
tfine=linspace(0,T,100);
clean_data_100 = sol_richards(tt,true_params,C0);
rng(1); % reproducibility
sigma=400;
noisy_data_100 = clean_data_100 + normrnd(0,sigma,size(clean_data_100));

numpts=41;
fixed=[0,1,1,0];
fixed_param_val=[r,d,g,k];
lb=[0.01, 0, 0, 2000];
ub=[1.00, 1, 2,10000];
param_names={'r','\delta','\gamma','K'};
num_params=size(fixed_param_val,2);
num_free_params=sum(1-fixed);
numeric_params=[T,nt];
opt.lb=[0.01, 0.01, 0.1,  500];
opt.ub=[1.00, 1.00, 4.0, 5000];
opt.alg=1;
[mle,mle_sigma,max_l] = optimize_likelihood_general(@richards_sq_err,fixed_param_val,fixed,noisy_data_100,numeric_params,C0,opt);
fprintf(['Overall max likelihood param is: ',repmat('%.3f,',size(mle)),'sigma=%.3f,\n'],mle,mle_sigma);
optimal_param_vals=fixed_param_val';
optimal_param_vals(fixed==0)=mle;

solnfig=figure;
hold on;
plot(tt,clean_data_100,'DisplayName','Clean data');
plot(tt,noisy_data_100,'DisplayName','Noisy data');
plot(tfine,sol_richards(tfine,optimal_param_vals,C0),'DisplayName','MLE fit');
legend;

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
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_sq_err,initial,fixed_params,noisy_data_100,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
    for i=mle_idx-1:-1:1
        fprintf('Optimizing for %s=%.3f\n',param_names{param},param_vals(param,i));
        initial(fixed_params==0)=minimizers{param,i+1};
        initial(param)=param_vals(param,i);
        [minimizer,~,max_ls(param,i)] = optimize_likelihood_general(@richards_sq_err,initial,fixed_params,noisy_data_100,numeric_params,C0,opt);
        minimizers{param,i}=minimizer;
        %save([prefix,'_',figtitle,'.mat'],'-mat');
    end
end

plfig=figure('Position',[100 100 1400 400],'color','w');
free_param_count=0;
zs = cell(num_params,1);
conf_interval=nan(num_params,1);
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on;
    xx=param_vals(param,:);
    yy=max_ls(param,:)-max(max_ls(param,:));
    plot(xx,yy);
    plot([min(param_vals(param,:)),max(param_vals(param,:))],[-1.92,-1.92]);
    plot([true_params(param),true_params(param)],[-10,10],'--r'); % true max
    plot([optimal_param_vals(param),optimal_param_vals(param)],[-10,10],'--g'); % MLE
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    xlim([min(param_vals(param,:)),max(param_vals(param,:))]);
    ylim([-2.5,0]);
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

save([filename,'.mat']);
saveas(solnfig,[filename,'_soln.png']);
saveas(plfig,[filename,'_pl.png']);

%% do a profile likelihood with C0=1

%% do a profile likelihood with C0=2000

%% plot r range, k range vs C0

params=true_params;
fixed=[0,1,0,0];
numeric_params=[T,nt];
C0s=[linspace(1,300,100),linspace(301,2500,100)];
rrangefun=@(C0) logistic_bd_c0_confintrange(C0,params,1,fixed,numeric_params,[0.1,2]);
rranges=arrayfun(rrangefun,C0s);

krangefun=@(C0) logistic_bd_c0_confintrange(C0,params,4,fixed,numeric_params,[500,10000]);
kranges=arrayfun(krangefun,C0s);

%% plot
rangefig=figure('Position',[100 100 1200 500],'color','w');
tl=tiledlayout(1,2);
nexttile;
%subplot(1,2,1);
plot(C0s,rranges);
xlim([0,2500]);
ylim([0,1.6]);
xlabel('$C_0$','Interpreter','latex');
ylabel('$\Delta r$','Interpreter','latex');
nexttile;
%subplot(1,2,2);
plot(C0s,kranges);
xlim([0,2500]);
ylim([200,1000]);
xlabel('$C_0$','Interpreter','latex');
ylabel('$\Delta K$','Interpreter','latex');

axs=tl.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', 16);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
t.TileSpacing = 'tight';
t.Padding = 'none';

%% find minimum of the confidence intervals

% fmincon don't work, seems to be locally flat
%[best_C0_r, rrange_min]=fmincon(rrangefun,100,[],[],[],[],0,2000); 
[best_C0_r, rrange_min]=fminbnd(rrangefun,10,100); 
[best_C0_k, krange_min]=fminbnd(krangefun,500,2000); 

%% save
save('figure/richards_bd_c0_confint_2.mat');
saveas(rangefig,'figure/richards_bd_c0_confint_2.png');
saveas(rangefig,'figure/richards_bd_c0_confint_2.fig');
saveas(rangefig,'figure/richards_bd_c0_confint_2.eps','epsc');