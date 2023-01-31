function [minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,alg,xs,noiseweight)
%Build a string that defines the likelihood function in terms of the right
%parameters
%  fixed_params: which parameters are fixed at their initial value (1: fixed, 0: free)
%  initial: initial guess for all parameters
%  lb,ub: lower/upper bound
%  noisy_data,T,t_skip,x_skip: to be fed to f
%  threshold: -1 for full density data, otherwise threshold the data
%  ic: initial condition, set to NaN if using default
%  alg: algorithm (1: interior-point, default; 0: pattern search for nonsmooth; 2: global search)
%  (should be smooth with full density data, nonsmooth with thresholded data)
%  xs: for 1D only, provide spatial grid points (nan for default)
%  noiseweight: weight for contribution to the error/residual from each
%  point as function of x (leave as NaN for uniform)


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
f_str=strcat('f=@(x) squared_error(noisy_data,',param_str,',numeric_params,t_skip,x_skip,threshold,ic,xs,noiseweight);');
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

if alg==1
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    options.UseParallel=true;
    options.Display='iter';
    options.Diagnostics='on';
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=true;
    problem.objective=f;
    problem.x0=initial(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0);
    problem.ub=ub(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,~,~,~,grad,hessian] = fmincon(problem);
elseif alg==0
    options=optimoptions('patternsearch');
    options.Display='iter';
    problem.objective=f;
    problem.x0=initial(fixed_params==0);
    problem.solver='patternsearch';
    problem.lb=lb(fixed_params==0);
    problem.ub=ub(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err] = patternsearch(problem);
    grad=NaN;
    hessian=NaN;
else
    %alg==2
    gs = GlobalSearch;
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    options.Display='iter';
    options.UseParallel=false;
    options.Diagnostics='on';
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=true;
    problem.objective=f;
    problem.x0=initial(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0);
    problem.ub=ub(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,exitflag,gs_output] = run(gs,problem);
    grad=NaN;
    hessian=NaN;
    fprintf('gs exitflag: %d\n',exitflag);
    get(gs_output); % full display
end
if ~iscell(noisy_data)
    % just 1 pde variable
    if ndims(noisy_data)==2
        % 1 spatial dimension
        N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
    else
        % 2 spatial dimension
        N=prod(ceil(size(noisy_data)./[t_skip,x_skip,x_skip]));
    end
else
    % 2 or more pde variable
    if ndims(noisy_data{1})==2
        N=prod(ceil(size(noisy_data{1})./[t_skip,x_skip]));
    else
        N=prod(ceil(size(noisy_data{1})./[t_skip,x_skip,x_skip]));
    end
end
[max_l,sigma2]= log_likelihood(min_sq_err,N);
sigma=sqrt(sigma2);
fprintf(['optimization outcome: ',repmat('%.3f,',size(minimizer)),'sigma=%.3f\n'],minimizer,sigma);

end

