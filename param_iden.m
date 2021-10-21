load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_1d_20211012_153239_Dc=1_r=1_n=0_alpha=1_beta=1.mat')
%l=log_likelihood_1d(cc_noisy,1,1,0.05);
% the optimization parameters are Dc, r, sigma2
noise_strength=0.05;
noisy_data=cc_noisy_005;
t_skip=5;
x_skip=12;
f=@(x) -log_likelihood_1d(noisy_data,x(1),x(2),1,1,x(3),t_skip,x_skip);
true_params=[1,1,noise_strength];

options=optimoptions('fmincon');
problem.objective=f;
problem.x0=[1,1,noise_strength];
problem.solver='fmincon';
problem.lb=[0;0;0];
problem.ub=[3;3;1];
problem.options=options;
[overall_minimizer,overall_max_l] = fmincon(problem);

fprintf('Overall max likelihood param is: Dc=%.3f, r=%.3f, sigma2=%.3f\n',overall_minimizer);

%% profile likelihood for Dc
% now the free parameters are r and sigma2

numpt=50;
Dc_range=[0.95,1.05];
Dcs = linspace(Dc_range(1),Dc_range(2),numpt)';
ls_Dc_profile=zeros(numpt,1);
for i=1:numpt
    Dc=Dcs(i);
    f=@(x) -log_likelihood_1d(noisy_data,Dc,x(1),1,1,x(2),t_skip,x_skip);
    
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
    [minimizer,ls_Dc_profile(i)] = fmincon(problem);
end

%% profile likelihood for r
% now the free parameters are Dc and sigma2
numpt=50;
r_range=[0.95,1.05];
rs = linspace(r_range(1),r_range(2),numpt)';
ls_r_profile=zeros(numpt,1);
for i=1:numpt
    r=rs(i);
    f=@(x) -log_likelihood_1d(noisy_data,x(1),r,1,1,x(2),t_skip,x_skip);
    
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
    [minimizer,ls_r_profile(i)] = fmincon(problem);
end

%% profile likelihood for sigma2
% now the free parameters are Dc and r
numpt=50;
sigma2_range=[noise_strength-0.005,noise_strength+0.005];
sigma2s = linspace(sigma2_range(1),sigma2_range(2),numpt)';
ls_sigma2_profile=zeros(numpt,1);
for i=1:numpt
    sigma2=sigma2s(i);
    f=@(x) -log_likelihood_1d(noisy_data,x(1),x(2),1,1,sigma2,t_skip,x_skip);
    
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
    [minimizer,ls_sigma2_profile(i)] = fmincon(problem);
end

%% plot
fig=figure('Position',[100 100 1400 400],'color','w');
figtitle=['noise=',num2str(noise_strength),', fixed alpha,beta,','tskip=',num2str(t_skip),', xskip=',num2str(x_skip),'.png'];
sgtitle(figtitle);
subplot(1,3,1);
hold on;
plot(Dcs,-ls_Dc_profile-max(-ls_Dc_profile));
plot(Dcs,-2*ones(size(Dcs)));
xlabel('Dc');
ylabel('l');
axis('square');
xlim(Dc_range);
ylim([-2.5,0]);
hold off;

subplot(1,3,2);
hold on;
plot(rs,-ls_r_profile-max(-ls_r_profile));
plot(rs,-2*ones(size(Dcs)));
xlabel('r');
ylabel('l');
axis('square');
xlim(r_range);
ylim([-2.5,0]);
hold off;

subplot(1,3,3);
hold on;
plot(sigma2s,-ls_sigma2_profile-max(-ls_sigma2_profile));
plot(sigma2s,-2*ones(size(Dcs)));
xlabel('\sigma^2');
ylabel('l');
axis('square');
xlim(sigma2_range);
ylim([-2.5,0]);
hold off;

saveas(fig,figtitle);
%%
save([prefix,'_paramiden_noise=',num2str(noise_strength),'tskip=',num2str(t_skip),', xskip=',num2str(x_skip),'.mat'],'-mat');