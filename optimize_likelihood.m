function [minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,T,t_skip,x_skip,ic)
%Build a string that defines the likelihood function in terms of the right
%parameters
%  fixed_params: which parameters are fixed at their initial value (1: fixed, 0: free)
%  initial: initial guess for all parameters
%  lb,ub: lower/upper bound
%  noisy_data,T,t_skip,x_skip: to be fed to f
%  ic: initial condition, optional


param_str='[';
paramcount=1;
for i=1:size(fixed_params,2)
    if ~fixed_params(i)
        param_str=strcat(param_str,'x(',num2str(paramcount),'),');
        paramcount = paramcount+1;
    else
        param_str=strcat(param_str,num2str(initial(i)),',');
    end
end
param_str=strcat(param_str,']');
if exist('ic','var')
    f_str=strcat('f=@(x) squared_error(noisy_data,T,',param_str,',t_skip,x_skip,ic);');
else
    f_str=strcat('f=@(x) squared_error(noisy_data,T,',param_str,',t_skip,x_skip);');
end
eval(f_str);

% % at initial point log likelihood is -Inf
% % if sigma2 is not fixed, double it should increase likelihood
% % otherwise, just put -Inf
% iter=0;
% while f(initial(fixed_params==0)) == Inf
%     if fixed_params(end)==1 || iter > 2
%         minimizer=initial(fixed_params==0);
%         max_l=-Inf;
%         grad=NaN;
%         hessian=NaN;
%         return;
%     else
%         initial(end)=initial(end)*2;
%         ub(end)=ub(end)*2;
%         iter=iter+1;
%     end
% end

options=optimoptions('fmincon','Algorithm','interior-point');
options.Display='iter';
problem.objective=f;
problem.x0=initial(fixed_params==0);
problem.solver='fmincon';
%problem.lb=lb(fixed_params==0);
problem.lb=zeros(size(lb(fixed_params==0)));
%problem.ub=ub(fixed_params==0);
ub=[20000,5,10,10,10,10];
problem.ub=ub(fixed_params==0);
problem.options=options;
[minimizer,min_sq_err,~,~,~,grad,hessian] = fmincon(problem);
if ndims(noisy_data)==2
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
else
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip,x_skip]));
end
[max_l,sigma2]= log_likelihood(min_sq_err,N);
sigma=sqrt(sigma2);
fprintf(['optimization outcome: ',repmat('%.3f,',size(minimizer)),'sigma=%.3f\n'],minimizer,sigma);

end

