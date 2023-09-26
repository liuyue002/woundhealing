% Run Markov Chain Monte Carlo with Metropolis-Hastings algorithm to find
% the posterior distribution of parameters

load('experimental_data/processed_data/xy1_data_processed.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
threshold=-1;

fixed_param_val=[1300,0.27,1,1,1,0,2650];
initial=  [1300,0.27,1,1,1,0,2650;...
           1500,0.22,1,1,1,0,2600;...
           1100,0.32,1,1,1,0,2750;...
           1400,0.30,1,1,1,0,2700];
scale=[1,0.0001,0.0001,0.0001,0.0001,0.0001,1];
param_names={'D0','r','alpha','beta','gamma','n','k'};
%leave sigma out
num_params=7;
%if fixed(i)==1, then the ith param is set to the true value and not optimized over
fixed=[0,0,1,1,1,1,0];
num_free_params=sum(1-fixed);
numeric_params=[T, dt/100, 100, NaN, NaN, 1];

% sensible bound for the parameters
lb_opt=[ 100, 0.01,  0.01,  0.01,  0.01, 0,   500];
ub_opt=[5000, 5.00,  99.0,  99.0,  99.0, 4, 20000];
noiseweight = max(num_pts_in_bins,1)';

figtitle=sprintf(['radial1D,mcmc_multi,fixed=[',repmat('%d,',size(fixed)),'],3'],fixed);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

%%
maxiter=10000;
iter_check=100; % frequency to check acceptance rate
burnin=100;
m=4; % number of chains
%samples(:)=repmat({zeros(maxiter,num_free_params)},1,num_chains);
%ls=repmat({zeros(maxiter,1)},1,num_chains);
samples=zeros(maxiter,num_free_params,m);
ls=zeros(maxiter,m);
stepsize=ones(m,1);
acceptance_count=zeros(m,1);
seq_means=zeros(maxiter/iter_check,num_free_params,m);
seq_means2=zeros(maxiter/iter_check,num_free_params,m);
seq_vars=zeros(maxiter/iter_check,num_free_params,m);
Bs=zeros(maxiter/iter_check,num_free_params);
Ws=zeros(maxiter/iter_check,num_free_params);
Vs=zeros(maxiter/iter_check,num_free_params);
VarVs=zeros(maxiter/iter_check,num_free_params);
Rs=zeros(maxiter/iter_check,num_free_params);
samples(1,:,:) = reshape(initial(:,fixed==0)',[1,3,4]);
termination_iter=-1;
for j=1:m
    ls(1,j)=log_likelihood(squared_error(noisy_data,initial(j,:),numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
end
%%
for iter=10001:maxiter
    epoch=floor(iter/iter_check);
    n=iter-burnin; % number of samples
    for j=1:m
        proposal=samples(iter-1,:,j)+randn(1,num_free_params).*scale(fixed==0).*stepsize(j);
        proposal=max(proposal,lb_opt(fixed==0));
        proposal=min(proposal,ub_opt(fixed==0));
        proposal_params=fixed_param_val;
        proposal_params(fixed==0)=proposal;
        l=log_likelihood(squared_error(noisy_data,proposal_params,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
        r=exp(l-ls(iter-1,j));
        if rand(1)<r
            % accept
            samples(iter,:,j)=proposal;
            ls(iter,j)=l;
            acceptance_count(j)=acceptance_count(j)+1;
            fprintf(['iter=%d, chain %d accepted [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,j,proposal,r);
        else
            % reject
            samples(iter,:,j)=samples(iter-1,:,j);
            ls(iter,j)=ls(iter-1,j);
            fprintf(['iter=%d, chain %d rejected [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,j,proposal,r);
        end
        
        if mod(iter,iter_check)==0
            accept_rate = acceptance_count(j)/iter_check;
            fprintf('From iter %d to %d, chain %d acceptance rate =  %.2f\n',iter-100, iter,j, accept_rate);
            if  accept_rate < 0.2
                stepsize(j)=stepsize(j)*0.9;
            elseif accept_rate > 0.6
                stepsize(j)=stepsize(j)*1.1;
            end
            fprintf('Updated chain %d Stepsize = %.3f\n',j,stepsize(j));
            acceptance_count(j)=0;
            
            if iter>burnin
                seq_means(epoch,:,j)=mean(samples(burnin:iter,:,j),1);
                seq_means2(epoch,:,j)=mean(samples(burnin:iter,:,j).^2,1);
                seq_vars(epoch,:,j)=var(samples(burnin:iter,:,j),0,1);
            end
        end
    end
    
    if iter > burnin && mod(iter,iter_check)==0
        allmean = mean(seq_means(epoch,:,:),3); % 1 x num_free_params
        Bs(epoch,:)=n*var(seq_means(epoch,:,:),0,3);
        Ws(epoch,:)=mean(seq_vars(epoch,:,:),3);
        Vs(epoch,:)= (n-1)/n*Ws(epoch,:) + (1/n)*Bs(epoch,:) + Bs(epoch,:)/(m*n);
        cov1=zeros(1,num_free_params);
        cov2=zeros(1,num_free_params);
        for param=1:num_free_params
            c=cov(squeeze(seq_vars(epoch,param,:)),squeeze(seq_means(epoch,param,:).^2));
            cov1(param)=c(1,2);
            c=cov(squeeze(seq_vars(epoch,param,:)),squeeze(seq_means(epoch,param,:)));
            cov2(param)=c(1,2);
        end
        VarVs(epoch,:)=((n-1)/n)^2/m*var(seq_vars(epoch,:,:),0,3) +...
                       2*((m+1)/(m*n*(m-1)))^2*(Bs(epoch,:)).^2 +...
                       2*(m+1)*(n-1)/(m^2 *n)*(cov1-2*allmean.*cov2);
        df=2*Vs(epoch,:).^2./VarVs(epoch,:);
        Rs(epoch,:)=Vs(epoch,:)./Ws(epoch,:) .* (df./(df-2));
        fprintf(['At iter=%d, B= [',repmat('%.3f,',1,num_free_params),']\n'],iter,Bs(epoch,:));
        fprintf(['At iter=%d, W= [',repmat('%.3f,',1,num_free_params),']\n'],iter,Ws(epoch,:));
        fprintf(['At iter=%d, V= [',repmat('%.3f,',1,num_free_params),']\n'],iter,Vs(epoch,:));
        fprintf(['At iter=%d, R= [',repmat('%.3f,',1,num_free_params),']\n'],iter,Rs(epoch,:));
        if all(Rs(epoch,:) < 1.05 )
            %break;
            fprintf('Termination condition reached!!!!!!!!!!!!\n');
            if termination_iter==-1
                termination_iter=iter;
            end
        end
    end
end
fprintf('First time termination condition reached at %d iter\n',termination_iter);
%% plot

%% save
%saveas(fig,[prefix,'_',figtitle,'.png']);
save([prefix,'_',figtitle,'.mat'],'-mat');
fprintf('finish run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));
diary off;