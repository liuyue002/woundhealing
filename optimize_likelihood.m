function [minimizer,max_l,f_str,grad,hessian] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip)
%Build a string that defines the likelihood function in terms of the right
%parameters
%  fixed_params: which parameters are fixed at their initial value (1: fixed, 0: free)
%  initial: initial guess for all parameters
%  lb,ub: lower/upper bound
% noisy_data,T,t_skip,x_skip: to be fed to f

f_str='f=@(x) -log_likelihood_1d(noisy_data,T,[';
paramcount=1;
for i=1:size(fixed_params,2)-1
    if ~fixed_params(i)
        f_str=strcat(f_str,'x(',num2str(paramcount),'),');
        paramcount = paramcount+1;
    else
        f_str=strcat(f_str,num2str(initial(i)),',');
    end
end
f_str=strcat(f_str,'],');
if ~fixed_params(end)
    f_str=strcat(f_str,'x(',num2str(paramcount),'),');
else
    f_str=strcat(f_str,num2str(initial(end)),',');
end
f_str=strcat(f_str,'t_skip,x_skip);');
eval(f_str);

% at initial point log likelihood is -Inf
% if sigma2 is not fixed, double it should increase likelihood
% otherwise, just put -Inf
iter=0;
while f(initial(fixed_params==0)) == Inf
    if fixed_params(end)==1 || iter > 2
        minimizer=initial(fixed_params==0);
        max_l=-Inf;
        grad=NaN;
        hessian=NaN;
        return;
    else
        initial(end)=initial(end)*2;
        ub(end)=ub(end)*2;
        iter=iter+1;
    end
end

options=optimoptions('fmincon');
problem.objective=f;
problem.x0=initial(fixed_params==0);
problem.solver='fmincon';
problem.lb=lb(fixed_params==0);
problem.ub=ub(fixed_params==0);
problem.options=options;
[minimizer,max_l,~,~,~,grad,hessian] = fmincon(problem);
max_l= -max_l;

end

