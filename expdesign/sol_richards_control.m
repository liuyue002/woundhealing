function sol = sol_richards_control(t,params,C0,u_d,u_K,u_r)
%numeric solution for Richards model with death term
% (includes logistic growth as special case with gamma=1)
% with control function for death and carrying capacity
% u_d, u_k should be function handles
% Eq: dC/dt=r*C*(1-(C/K)^gamma) - d*C
% params=[r,d,gamma,K]
r=params(1);
d=params(2);
gamma=params(3);
K=params(4);

ode=@(t,C)(r+u_r(t))*C*(1-(C/(K-u_K(t)))^gamma) - (d+u_d(t))*C;

% smaller step size especially for large u_K, such that when it's turned on
% it can cause the solution to sharply drop
opt=odeset('MaxStep',(t(2)-t(1))/100);
[tt,X] = ode45(ode,[t(1),t(end)],C0,opt);
sol = interp1(tt,X,t);
end