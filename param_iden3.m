load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211015_163234_Dc=500_r=0.05_n=0_alpha=1_beta=1.mat');
%l=log_likelihood_1d(cc_noisy,1,1,0.05);
% the optimization parameters are Dc, r, alpha, beta, sigma2
noise_strength=0.01;
noisy_data=cc_noisy_001;
t_skip=10;
x_skip=30;
%f=@(x) -log_likelihood_1d(noisy_data,T,x(1),x(2),x(3),x(4),x(5),t_skip,x_skip);
true_params=[Dc,r,alpha,beta,noise_strength];
lb=true_params*0.8;
ub=true_params*1.2;
param_names={'Dc','r','alpha','beta','sigma2'};
num_params=size(true_params,2);
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,0,0,0]; 
num_free_params=sum(1-fixed);

%% overall max likelihood
[overall_minimizer,max_l,f_str] = optimize_likelihood(fixed,true_params,lb,ub,noisy_data,T,t_skip,x_skip);

fprintf('Overall max likelihood param is: Dc=%.3f, r=%.3f, sigma2=%.3f\n',overall_minimizer);

% % fisher information
addpath('/home/liuy1/Documents/woundhealing/DERIVESTsuite');
eval(f_str);
[grad,~,~] = gradest(f,overall_minimizer);
[hess,err] = hessian(f,overall_minimizer);
%% profile likelihood for each param
numpts=20;
param_vals=zeros(num_params,numpts);
max_ls=zeros(num_params,numpts);
for param=1:num_params
    if fixed(param)
        continue;
    end
    param_vals(param,:)=linspace(lb(param),ub(param),numpts);
    fixed_params=fixed;
    fixed_params(param)=1;
    initial=true_params;
    for i=1:numpts
        initial(param)=param_vals(param,i);
        [minimizer,max_ls(param,i)] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip);
    end
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=['noise=',num2str(noise_strength),', free alpha,beta,','tskip=',num2str(t_skip),', xskip=',num2str(x_skip)];
sgtitle(figtitle);
free_param_count=0;
for param=1:num_params
    if fixed(param)
        continue;
    end
    free_param_count = free_param_count+1;
    subplot(1,num_free_params,free_param_count);
    hold on;
    plot(param_vals(param,:),max_ls(param,:)-max(max_ls(param,:)));
    plot(param_vals(param,:),-2*ones(1,numpts));
    xlabel(param_names{param});
    ylabel('log(L)');
    axis('square');
    ylim([-2.5,0]);
    hold off;
end
saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
