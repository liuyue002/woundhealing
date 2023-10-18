function sol = sol_richards(t,params,C0)
%exact solution for Richards model with death term
% (includes logistic growth as special case with gamma=1)
% Eq: dC/dt=r*C*(1-(C/K)^gamma) - delta*C
% params=[r,d,gamma,K]
r=params(1);
d=params(2);
gamma=params(3);
K=params(4);
r_eff=r-d;
K_eff=K*(1-d/r)^(1/gamma);
%K_eff=K*abspow(1-d/r,1/gamma);
% if r_eff<=0
%     warning('bad parameters');
% end
%sol = K_eff*C0./(C0^gamma+(abspow(K_eff,gamma) - C0^gamma).*exp(-gamma*r_eff*t)).^(1/gamma);
%sol = K_eff*C0./(C0^gamma+(K_eff^gamma - C0^gamma).*exp(-gamma*r_eff*t)).^(1/gamma);
sol = K_eff*C0./( K_eff^gamma.*exp(-gamma*r_eff*t) + C0^gamma.*(1-exp(-gamma*r_eff*t)) ).^(1/gamma);
end

% function y = abspow(x,p)
% y = abs(x)^p*sign(x);
% end