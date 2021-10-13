load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211012_153239_Dc=1_r=1_n=0_alpha=1_beta=1.mat')
%l=log_likelihood_1d(cc_noisy,1,1,0.05);
% the optimization parameters are Dc, r, sigma2
noise_strength=0.01;
noisy_data=cc_noisy_001;
f=@(x) -log_likelihood_1d(noisy_data,x(1),x(2),x(3));
true_params=[1,1,noise_strength];

options=optimoptions('fmincon');
problem.objective=f;
problem.x0=[1,1,noise_strength];
problem.solver='fmincon';
problem.lb=[0;0;0];
problem.ub=[3;3;1];
problem.options=options;
overall_minimizer = fmincon(problem);
overall_max_l = -f(overall_minimizer);

fprintf('Overall max likelihood param is: Dc=%.3f, r=%.3f, sigma2=%.3f\n',overall_minimizer);

%% profile likelihood for Dc
% now the free parameters are r and sigma2

numpt=50;
Dcs = linspace(0.95,1.05,numpt)';
ls_Dc_profile2=zeros(numpt,1);
for i=1:numpt
    Dc=Dcs(i);
    f=@(x) -log_likelihood_1d(noisy_data,Dc,x(1),x(2));
    
    options=optimoptions('fmincon');
    problem.objective=f;
    if i==1
        problem.x0=[1,noise_strength];
    else 
        problem.x0=minimizer;
    end
    problem.solver='fmincon';
    problem.lb=[0;0];
    problem.ub=[3;1];
    problem.options=options;
    minimizer = fmincon(problem);
    ls_Dc_profile2(i)=f(minimizer);
end

fig=figure;
hold on
plot(Dcs,-ls_Dc_profile2-overall_max_l);
plot(Dcs,-2*ones(size(Dcs)));
xlabel('Dc');
ylabel('l');
hold off
xlim([0.95,1.05]);
ylim([-2.5,0]);
%% profile likelihood for r
% now the free parameters are Dc and sigma2
numpt=50;
rs = linspace(0.95,1.05,numpt)';
ls_r_profile=zeros(numpt,1);
for i=1:numpt
    r=rs(i);
    f=@(x) -log_likelihood_1d(noisy_data,x(1),r,x(2));
    
    options=optimoptions('fmincon');
    problem.objective=f;
    if i==1
        problem.x0=[1,noise_strength];
    else 
        problem.x0=minimizer;
    end
    problem.solver='fmincon';
    problem.lb=[0;0];
    problem.ub=[3;1];
    problem.options=options;
    minimizer = fmincon(problem);
    ls_r_profile(i)=f(minimizer);
end

fig=figure;
hold on
plot(rs,-ls_r_profile-overall_max_l);
plot(rs,-2*ones(size(Dcs)));
xlabel('r');
ylabel('l');
hold off
xlim([0.95,1.05]);
ylim([-5,0]);

%% profile likelihood for sigma2
% now the free parameters are Dc and r
numpt=50;
sigma2s = linspace(noise_strength-0.005,noise_strength+0.005,numpt)';
ls_sigma2_profile=zeros(numpt,1);
for i=1:numpt
    sigma2=sigma2s(i);
    f=@(x) -log_likelihood_1d(noisy_data,x(1),x(2),sigma2);
    
    options=optimoptions('fmincon');
    problem.objective=f;
    if i==1
        problem.x0=[1,1];
    else 
        problem.x0=minimizer;
    end
    problem.solver='fmincon';
    problem.lb=[0;0];
    problem.ub=[3;3];
    problem.options=options;
    minimizer = fmincon(problem);
    ls_sigma2_profile(i)=f(minimizer);
end

fig=figure;
hold on
plot(sigma2s,-ls_sigma2_profile-overall_max_l);
plot(sigma2s,-2*ones(size(Dcs)));
xlabel('Dc');
ylabel('l');
hold off
xlim([0.04,0.06]);
ylim([-5,0]);

%%
save([prefix,'_noise=',num2str(noise_strength),'.mat'],'-mat');