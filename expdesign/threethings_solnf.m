function exact_soln = threethings_solnf(params,numeric_params,x0)
% params: parameters of the model
% numeric_params: [T,nt]
T=numeric_params(1);
nt=numeric_params(2);
tt=linspace(0,T,nt);
M = [-params(2), 0, 0;
     params(4), -params(5), 0;
     params(7), params(8), -params(9)];
b=[params(1);
   params(3);
   params(6)];
exact_solnf = @(t)expm(t*M)*(x0+M\b) - M\b;
exact_soln=arrayfun(exact_solnf,tt,'UniformOutput',false);
exact_soln=cell2mat(exact_soln);
end