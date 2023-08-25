%% general setup
% whether the effects of the control variables are absolute (additive) or
% relative (multiplicative)
absolute = true;

% uall=[ur,ud,uk];
if absolute
    % effects of u's are additivie
    fgen = @(C,r,d,gamma,K,uall) (r+uall(1))*C.*(1-(C./(K-uall(3))).^gamma)-(d+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) (r+uall(1))*(1-(1+gamma)*(C./(K-uall(3))).^gamma)-(d+uall(2));
    % lower/upper bound for control variables
    uklb=0;
    urlb=0;
    udlb=0;
    ukub=1300;
    urub=0.4;
    udub=0.2;
    % weight of control cost
    alphak=0.03;
    alphar=5e5;
    alphad=5e5;

else
    % effects of u's are multiplicative
    fgen = @(C,r,d,gamma,K,uall) r*(1+uall(1))*C.*(1-(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2))*C;
    dfdCgen= @(C,r,d,gamma,K,uall) r*(1+uall(1))*(1-(1+gamma)*(C./(K*(1-uall(3)))).^gamma)-d*(1+uall(2));
    % lower/upper bound for control variables
    uklb=0;
    urlb=0;
    udlb=0;
    ukub=0.5;
    urub=0.5;
    udub=0.5;
    % weight of control cost
    alphak=3e4;
    alphar=1.3e6;
    alphad=1.3e6;
end

r1=0.45;
d1=0.15;
gamma1=1;
K1=3900;

r2=0.3;
d2=0;
gamma2=1;
K2=2600;

C0=100;
T=25;
upts=100;
odeopts = odeset('RelTol',1e-4,'AbsTol',1e-4,'MaxStep',T/upts);
omega=0.1;
Hgen = @(C1,C2,lambda1,lambda2,uk,ur,ud) (C1-C2).^2-alphak*uk.^2-alphar*ur.^2-alphad*ud.^2 + lambda1*fgen(C1,r1,d1,gamma1,K1,uk,ur,ud) + lambda2*fgen(C2,r2,d2,gamma2,K2,uk,ur,ud);

%% Decide which control is active (inactive ones set to 0)
ur_active = false;
ud_active = false;
uk_active = true;

% u is a subset of [ur,ud,uk]
f=@(C,r,d,gamma,K,u) fgen(C,r,d,gamma,K,combine_u(u,uk_active,ur_active,ud_active));
dfdC=@(C,r,d,gamma,K,u) dfdCgen(C,r,d,gamma,K,combine_u(u,uk_active,ur_active,ud_active));
H=@(C1,C2,lambda1,lambda2,u) Hgen(C1,C2,lambda1,lambda2,combine_u(u,uk_active,ur_active,ud_active));

filename=sprintf('simulations/twomodel_control_gen_%s_active=[%d,%d,%d],alpha=[%.2f,%.2f,%.2f],omega=%.2f',string(datetime,'yyyyMMdd_HHmmss'),ur_active,ud_active,uk_active,alphar,alphad,alphak,omega);
makeplot=true;
giffile=[filename,'.gif'];
logfile=[filename,'.txt'];
matfile=[filename,'.mat'];
if makeplot
    diary(logfile);
end
fprintf('start run on: %s\n',string(datetime,'yyyyMMdd_HHmmss'));


%%%%%%%refactor on-going

%% helper functions
function uall = combine_u(u,ur_active,ud_active,uk_active)
uall=[0,0,0];
uall([ur_active,ud_active,uk_active])=u;
end