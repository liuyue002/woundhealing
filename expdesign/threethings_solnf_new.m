function exact_soln = threethings_solnf_new(params,numeric_params,x0)
% params: parameters of the model
% numeric_params: [T,nt]
T=numeric_params(1);
nt=numeric_params(2);
tt=linspace(0,T,nt);
M = [-params(4), 0, 0;
     params(5), -params(6), 0;
     params(7), params(8), -params(9)];
b=[params(1);params(2);params(3)];
x0(2)=params(10);
exact_solnf = @(t)expm(t*M)*(x0+M\b) - M\b;
exact_soln=arrayfun(exact_solnf,tt,'UniformOutput',false);
exact_soln=cell2mat(exact_soln);
end