%% just do finite difference with respect to K with exact model solution

C0=100;
nt=100;
T=25;
t=linspace(0,T,nt);
params=[0.45,0.15,1,3900];
dp=0.001;
sol1 = sol_richards(t,params,C0);
solK = sol_richards(t,[params(1:3),params(4)+dp],C0);
diffK=(solK-sol1)./dp;
solr = sol_richards(t,[params(1)+dp,params(2:4)],C0);
diffr=(solr-sol1)./dp;
sold = sol_richards(t,[params(1),params(2)+dp,params(3:4)],C0);
diffd=(sold-sol1)./dp;


%%
figK=figure;
plot(t,diffK);
xlabel('$t$','Interpreter','latex');
ylabel('$\phi_{K}$','Interpreter','latex');
title('sensitivity');

figr=figure;
plot(t,diffr);
xlabel('$t$','Interpreter','latex');
ylabel('$\phi_{r}$','Interpreter','latex');
title('sensitivity');

figd=figure;
plot(t,diffd);
xlabel('$t$','Interpreter','latex');
ylabel('$\phi_{d}$','Interpreter','latex');
title('sensitivity');

%% solve numerically for combined system C, phi_k
% r=params(1);
% d=params(2);
% K=params(4);
% ode=@(t,x) [r*x(1)*(1-x(1)/K) - d*x(1);...
%             x(2)*(r*(1-2*x(1)/K) - d) + r*x(1).^2/K^2];
% [tt,X] = ode45(ode,[0,T],[C0;0]);
% 
% figure;
% plot(tt,X(:,2));

%%

save('sensitivity.mat','-mat');