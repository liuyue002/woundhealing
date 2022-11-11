load('simulations/kevindata_circle_xy1_20220405_raw.mat');
noisy_data=C_radial_avg;
nFrame=size(noisy_data,1);
ic=noisy_data(1,:)';
dt=1/3;
T=(nFrame-1)*dt+0.001;% helps with off-by-1 rounding
t_skip=1;
x_skip=1;
N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
threshold=-1;

initial=  [1300,0.27,1,1,1,0,2650;...
           1300,0.27,1,1,1,0,2650;...
           1300,0.27,1,1,1,0,2650;...
           1300,0.27,1,1,1,0,2650];
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

figtitle=sprintf(['radial1D,mcmc_multi,fixed=[',repmat('%d,',size(fixed)),'],1'],fixed);
logfile = [prefix,'_',figtitle,'_log.txt'];
diary(logfile);
fprintf('start run on: %s\n',datestr(datetime('now'), 'yyyymmdd_HHMMSS'));

%%
maxiter=10000;
iter_check=100; % frequency to check acceptance rate
burnin=100;
num_chains=4;
%samples(:)=repmat({zeros(maxiter,num_free_params)},1,num_chains);
%ls=repmat({zeros(maxiter,1)},1,num_chains);
samples=cell(num_chains,1);
ls=cell(num_chains,1);
stepsize=repmat([1],num_chains,1);
acceptance_count=repmat([0],num_chains,1);
seq_means=cell(num_chains,1);
seq_vars=cell(num_chains,1);
Bs=cell(num_chains,1);
Ws=cell(num_chains,1);
Vs=cell(num_chains,1);
for j=1:num_chains
    samples{j}=zeros(maxiter,num_free_params);
    samples{j}(1,:)=initial{j};
    ls{j}=zeros(maxiter,1);
    ls{j}(1)=log_likelihood(squared_error(noisy_data,initial{j},numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
    seq_means{j}=zeros(maxiter/iter_check,num_free_params);
    seq_vars{j}=zeros(maxiter/iter_check,num_free_params);
    Bs{j}=zeros(maxiter/iter_check,num_free_params);
    Ws{j}=zeros(maxiter/iter_check,num_free_params);
    Vs{j}=zeros(maxiter/iter_check,num_free_params);
end
for iter=2:maxiter
    epoch=floor(iter/iter_check);
    num_sample=iter-burnin;
    for j=1:num_chains
        proposal=samples{j}(iter-1,:)+randn(1,num_free_params).*scale(fixed==0).*stepsize{j};
        proposal=max(proposal,lb_opt(fixed==0));
        proposal=min(proposal,ub_opt(fixed==0));
        proposal_params=fixed_param_val;
        proposal_params(fixed==0)=proposal;
        l=log_likelihood(squared_error(noisy_data,proposal_params,numeric_params,t_skip,x_skip,threshold,ic,rs,noiseweight),N);
        r=exp(l-ls{j}(iter-1));
        if rand(1)<r
            % accept
            samples{j}(iter,:)=proposal;
            ls{j}(iter)=l;
            acceptance_count(j)=acceptance_count(j)+1;
            fprintf(['iter=%d, chain %d accepted [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,j,proposal,r);
        else
            % reject
            samples{j}(iter,:)=samples{j}(iter-1,:);
            ls{j}(iter)=ls{j}(iter-1);
            fprintf(['iter=%d, rejected [',repmat('%.3f,',1,num_free_params),'], probability %.3f\n'],iter,proposal,r);
        end
        if mod(iter,iter_check)==0
            accept_rate = acceptance_count(j)/iter_check;
            fprintf('From iter %d to %d, chain %d acceptance rate =  %.2f\n',iter-100, iter,j, accept_rate);
            if  accept_rate < 0.2
                stepsize(j)=stepsize(j)*0.9;
            elseif accept_rate > 0.6
                stepsize(j)=stepsize(j)*1.1;
            end
            fprintf('Chain %d Stepsize = %.3f\n',j,stepsize);
            acceptance_count(j)=0;
            
            if iter>burnin
                seq_means{j}(epoch,:)=sum(samples{j}(burnin:end,:),1)./num_sample;
                seq_vars{j}(epoch,:)= ((samples{j}(burnin:end,:) - seq_means{j}(iter,:)).^2)./num_sample;
            end
        end
    end
    if iter > burnin && mod(iter,iter_check)==0
        allmean = seq_means{j}()
        Bs(iter)=num_sample*0;
        Ws(iter)=0;
        Vs(iter)=0;
        if Vs(iter)/Ws(iter) < 1.001
            break;
        end
    end
end