function [minimizer,sigma,max_l,param_str,grad,hessian] = optimize_likelihood(fixed_params,initial,lb,ub,noisy_data,numeric_params,t_skip,x_skip,threshold,ic,alg,xs,noiseweight,scaling)
%Optimize the likelihood function with respect to a subset of model
%parameters
%  fixed_params: which parameters are fixed at their initial value (1: fixed, 0: free)
%  initial: initial guess for all parameters
%  lb,ub: lower/upper bound
%  noisy_data: either experimental data or synthetic data
%  T: final time of the data
%  t_skip,x_skip: use 1 to use all available data, or an integer >1 to
%  down-sample the data
%  threshold: (removed feature, not used)
%  ic: initial condition for the simulation, set to NaN if using default
%  alg: algorithm (1: interior-point, default; 0: pattern search; 2: global search; 3: CMAES)
%  xs: for 1D only, provide spatial grid points (nan for default)
%  noiseweight: weight for contribution to the error/residual from each
%  point as function of x (leave as NaN for uniform)
%  scaling: scale for each parameter, so their sensitivity is approximately
%  the same (for the cell invasion model, [1000,1,1,1,1,1,1000] works),
%  leave as nan for automatic scaling by initial value (or no scaling for CMAES)

param_str='[';
paramcount=1;
auto_scale=true;
if isnan(scaling)
    scaling=ones(size(initial));
elseif size(scaling,1)>1
    scaling=scaling';
    auto_scale=false;
end
for i=1:size(fixed_params,2)
    if ~fixed_params(i)
        if auto_scale
            param_str=strcat(param_str,'x(',num2str(paramcount),'),');
            paramcount = paramcount+1;
        else
            param_str=strcat(param_str,'x(',num2str(paramcount),')*scaling(',num2str(i),'),');
            paramcount = paramcount+1;
        end
    else
        param_str=strcat(param_str,num2str(initial(i)),',');
    end
end
param_str=strcat(param_str,']');
f_str=strcat('f=@(x) squared_error(noisy_data,',param_str,',numeric_params,t_skip,x_skip,-1,ic,xs,noiseweight);');
eval(f_str);

if alg==1
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    options.Display='iter';
    options.Diagnostics='on';
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=auto_scale;
    problem.objective=f;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,exitflag,fmincon_output,~,grad,hessian] = fmincon(problem);
    fprintf('fmincon exitflag: %d\n',exitflag);
    disp(fmincon_output); % full display
elseif alg==0
    options=optimoptions('patternsearch');
    options.Display='iter';
    problem.objective=f;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='patternsearch';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err] = patternsearch(problem);
    grad=NaN;
    hessian=NaN;
elseif alg==2
    gs = GlobalSearch;
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    options.Display='iter';
    options.Diagnostics='on';
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=auto_scale;
    problem.objective=f;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,exitflag,gs_output] = run(gs,problem);
    grad=NaN;
    hessian=NaN;
    fprintf('gs exitflag: %d\n',exitflag);
    disp(gs_output); % full display
elseif alg==3
    %scaling=[1000,1,1,1,1,1,1000]';
    opts=cmaes('defaults');
    opts.SaveVariables = 'off';
    opts.LBounds=lb(fixed_params==0)' ./ scaling(fixed_params==0)';
    opts.UBounds=ub(fixed_params==0)' ./ scaling(fixed_params==0)';
    sigma_cmaes=0.3; % initial search radius for CMAES
    [minimizer,min_sq_err,counteval,stopflag,out,bestever] = cmaes(f,initial(fixed_params==0)'./scaling(fixed_params==0)',sigma_cmaes,opts);
    minimizer=minimizer';
    fprintf('CMAES counteval: %d, stopflag: \n',counteval);
    disp(stopflag);
    disp(out);
    disp(bestever);
    grad=NaN;
    hessian=NaN;
else
    error("Unknown optimization algorithm");
end
if ndims(noisy_data)==2
    % 1 spatial dimension
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip]));
else
    % 2 spatial dimension
    N=prod(ceil(size(noisy_data)./[t_skip,x_skip,x_skip]));
end
[max_l,sigma]= log_likelihood(min_sq_err,N);
fprintf(['optimization outcome: ',repmat('%.3f,',size(minimizer)),'sigma=%.3f\n'],minimizer,sigma);

end

