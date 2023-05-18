function sol = sol_logistic_bd(t,params,C0)
%exact solution for logistic model with linear death
% dC/dt = rC(1-(C/k)) - dC
% params=[r,d,K]
r=params(1);
d=params(2);
K=params(3);

sol=K*(r-d)*C0./( (K*(r-d)+r*C0).*exp(-(r-d)*t) + r*C0 );
end