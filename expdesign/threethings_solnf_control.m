function sol = threethings_solnf_control(params,numeric_params,x0)
% params: parameters of the model
% numeric_params: [T,nt,tau0A,tau1A,uA,tau0B,tau1B,uB,tau0C,tau1C,uC,]
T=numeric_params(1);
nt=numeric_params(2);
tau0A=numeric_params(3);
tau1A=numeric_params(4);
uA=numeric_params(5);
tau0B=numeric_params(6);
tau1B=numeric_params(7);
uB=numeric_params(8);
tau0C=numeric_params(9);
tau1C=numeric_params(10);
uC=numeric_params(11);
tt=linspace(0,T,nt);

% make sure x0 is a column vector
if size(x0,2)>1
    x0=x0';
end

window = @(t,max,tau0,tau1) max*(t>tau0).*(t<tau1);

% points where there's a jump in control
timepts=[0,T];
if uA ~= 0
    timepts = [timepts,tau0A,tau1A];
end
if uB ~= 0
    timepts = [timepts,tau0B,tau1B];
end
if uC ~= 0
    timepts = [timepts,tau0C,tau1C];
end
timepts=unique(timepts);
timepts=sort(timepts);

x0(2)=params(10);
sol=zeros(3,nt);
M = [-params(4), 0, 0;
     params(5), -params(6), 0;
     params(7), params(8), -params(9)];
for i=2:length(timepts)
    timemidpt = (timepts(i-1)+timepts(i))/2;
    b=[params(1)+window(timemidpt,uA,tau0A,tau1A);
       params(2)+window(timemidpt,uB,tau0B,tau1B);;
       params(3)+window(timemidpt,uC,tau0C,tau1C);];
    exact_solnf = @(t)expm((t-timepts(i-1))*M)*(x0+M\b) - M\b;
    t_index=(tt>=timepts(i-1)) & (tt<=timepts(i));
    sol(:,t_index) = cell2mat(arrayfun(exact_solnf,tt(t_index),'UniformOutput',false));
    x0 = exact_solnf(timepts(i));
end

end