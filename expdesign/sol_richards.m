function sol = sol_richards(t,params,C0)
%exact solution for Richards model
% (includes logistic growth as special case with gamma=1)
% params=[r,gamma,K]
r=params(1);
gamma=params(2);
K=params(3);
sol = K*C0./(C0^gamma+(K^gamma - C0^gamma).*exp(-gamma*r*t)).^(1/gamma);
end