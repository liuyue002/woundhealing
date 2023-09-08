function [t,sol] = sol_richards_bangbang(T,params,control_abs,control_params,C0)
%exact solution for Richards model with death term and stepwise (bangbang) control
% (includes logistic growth as special case with gamma=1)
% params=[r,d,gamma,K]
% control_abs: true if control is absolute/additive, false if
% relative/multiplicative
% control_params: [urmax, tau0r, tau1r, udmax, tau0d, tau1d, ukmax, tau0k, tau1k, ]
r=params(1);
d=params(2);
gamma=params(3);
k=params(4);

window = @(t,max,tau0,tau1) max*(t>tau0).*(t<tau1);

urmax=control_params(1);
tau0r=control_params(2);
tau1r=control_params(3);
urfun = @(t) window(t,urmax,tau0r,tau1r);
udmax=control_params(4);
tau0d=control_params(5);
tau1d=control_params(6);
udfun = @(t) window(t,udmax,tau0d,tau1d);
ukmax=control_params(7);
tau0k=control_params(8);
tau1k=control_params(9);
ukfun = @(t) window(t,ukmax,tau0k,tau1k);

% points where there's a jump in control
timepts=[0,T];
if urmax ~= 0
    timepts = [timepts,tau0r,tau1r];
end
if udmax ~= 0
    timepts = [timepts,tau0d,tau1d];
end
if ukmax ~= 0
    timepts = [timepts,tau0k,tau1k];
end
timepts=sort(timepts);

sol=[C0];
t=[0];
for i=2:length(timepts)
    % solve from timepts(i-1) to timepts(i)
    timemidpt = (timepts(i-1)+timepts(i))/2;
    ur = urfun(timemidpt);
    ud = udfun(timemidpt);
    uk = ukfun(timemidpt);

    if control_abs
        % Eq: dC/dt=(r+ur)*C*(1-(C/(K-uk))^gamma) - (delta+ud)*C
        rr = r+ur;
        dd = d + ud;
        kk = k - uk;
    else
        % Eq: dC/dt=r*(1+ur)*C*(1-(C/(K*(1-uk)))^gamma) - delta*(1+ud)*C
        rr = r*(1+ur);
        dd = d*(1+ud);
        kk = k*(1-uk);
    end
    
    nt = max(5, (timepts(i)-timepts(i-1))/0.1);
    t2 = linspace(timepts(i-1),timepts(i),nt);
    sol2 = sol_richards(t2-timepts(i-1),[rr,dd,gamma,kk],C0);

    C0 = sol2(end);
    t = [t,t2(2:end)];
    sol = [sol,sol2(2:end)];
end

end
