function sol = sol_richards_bangbang2(t,params,C0,urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k)
% re-parametrization of sol_richards_bangbang
T=t(end);
[tt,sol] = sol_richards_bangbang(T,params,true,[urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k],C0);
sol=interp1(tt,sol,t);
end