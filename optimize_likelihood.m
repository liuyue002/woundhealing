function [minimizer,max_l,f_str] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip)
%Build a string that defines the likelihood function in terms of the right
%parameters
%  fixed_params: which parameters are fixed at their initial value (1: fixed, 0: free)
%  initial: initial guess for all parameters
%  lb,ub: lower/upper bound
% noisy_data,T,t_skip,x_skip: to be fed to f

f_str='f=@(x) -log_likelihood_1d(noisy_data,T,';
paramcount=1;
for i=1:size(fixed_params,2)
    if ~fixed_params(i)
        f_str=strcat(f_str,'x(',num2str(paramcount),'),');
        paramcount = paramcount+1;
    else
        f_str=strcat(f_str,num2str(initial(i)),',');
    end
end
f_str=strcat(f_str,'t_skip,x_skip);');
eval(f_str);
options=optimoptions('fmincon');
problem.objective=f;
problem.x0=initial(fixed_params==0);
problem.solver='fmincon';
problem.lb=lb(fixed_params==0);
problem.ub=ub(fixed_params==0);
problem.options=options;
[minimizer,max_l] = fmincon(problem);
max_l= -max_l;
end

