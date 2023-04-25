function [minimizer,sigma,max_l] = optimize_likelihood_general(fn,initial,fixed_params,data,numeric_params,ic,opt)
%Optimize a likelihood function
% fn: function handle for the model solution (either simulation or exact soln)
% fn(params,data)
% initial_params: initial value for the parameters, as row vector
% fixed: if fixed(i)==1, then the parameter i is held fixed at initial_params(i)
% if ==0, then the parameter is optimized over
% data: the data to be fitted to
% numeric_params: numeric parameters for running simulation/obtaining soln
% ic: initial conditions for simulation/model soln
% other optional options:
% opt.lb, opt.ub: lower/upper bounds for parameters (default lb=0, no ub)
% opt.alg: algorithm for optimization (1: interior-point, default; 0: pattern search; 2: global search; 3: CMAES)
% opt.scaling: nan (default) means automatic scaling by initial_params,
% otherwise provide scaling for each parameter
% opt.logging: true (default) print lots of logs

%% parse options
lb = zeros(size(initial));
if isfield(opt,'lb')
    lb=opt.lb;
end
ub = 10*(initial+1);
if isfield(opt,'ub')
    ub=opt.ub;
end
alg=1;
if isfield(opt,'alg')
    alg=opt.alg;
end
auto_scale=true;
scaling=ones(size(initial));
if isfield(opt,'scaling') && ~any(isnan(opt.scaling))
    auto_scale=false;
    scaling=opt.scaling;
end
logging = true;
if isfield(opt,'logging')
    logging = opt.logging;
end

%% build objective function
param_str='[';
paramcount=1;
for i=1:size(fixed_params,2)
    if ~fixed_params(i)
        param_str=strcat(param_str,'x(',num2str(paramcount),')*scaling(',num2str(i),'),');
        paramcount = paramcount+1;
    else
        param_str=strcat(param_str,num2str(initial(i)),',');
    end
end
param_str=strcat(param_str,']');
f_str=strcat('f=@(x) fn(',param_str,',numeric_params,ic);');
eval(f_str);
objective=@(x) sum((f(x)-data).^2,'all');

%% call optimization routine

if alg==1
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    if logging
        options.Display='iter';
        options.Diagnostics='on';
    else
        options.Display='off';
        options.Diagnostics='off';
    end
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=auto_scale;
    problem.objective=objective;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,exitflag,fmincon_output] = fmincon(problem);
    if logging
        fprintf('fmincon exitflag: %d\n',exitflag);
        disp(fmincon_output); % full display
    end
elseif alg==0
    options=optimoptions('patternsearch');
    if logging
        options.Display='iter';
    else
        options.Display='off';
    end
    problem.objective=objective;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='patternsearch';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err] = patternsearch(problem);
elseif alg==2
    gs = GlobalSearch;
    options=optimoptions('fmincon','Algorithm','interior-point');
    %options=optimoptions('fmincon','Algorithm','sqp');
    if logging
        options.Display='iter';
        options.Diagnostics='on';
    else
        options.Display='off';
        options.Diagnostics='off';
    end
    options.MaxFunctionEvaluations=6000;
    %options.OptimalityTolerance=1e-6;
    %options.StepTolerance=1e-4;
    options.ScaleProblem=auto_scale;
    problem.objective=objective;
    problem.x0=initial(fixed_params==0)./ scaling(fixed_params==0);
    problem.solver='fmincon';
    problem.lb=lb(fixed_params==0)./ scaling(fixed_params==0);
    problem.ub=ub(fixed_params==0)./ scaling(fixed_params==0);
    problem.options=options;
    [minimizer,min_sq_err,exitflag,gs_output] = run(gs,problem);
    if logging
        fprintf('gs exitflag: %d\n',exitflag);
        disp(gs_output); % full display
    end
elseif alg==3
    %scaling=[1000,1,1,1,1,1,1000]';
    opts=cmaes('defaults');
    opts.SaveVariables = 'off';
    opts.LBounds=lb(fixed_params==0)' ./ scaling(fixed_params==0)';
    opts.UBounds=ub(fixed_params==0)' ./ scaling(fixed_params==0)';
    sigma_cmaes=0.3; % initial search radius for CMAES
    [minimizer,min_sq_err,counteval,stopflag,out,bestever] = cmaes(objective,initial(fixed_params==0)'./scaling(fixed_params==0)',sigma_cmaes,opts);
    minimizer=minimizer';
    if logging
        fprintf('CMAES counteval: %d, stopflag: \n',counteval);
        disp(stopflag);
        disp(out);
        disp(bestever);
    end
else
    error("Unknown optimization algorithm");
end

%% final result
N=numel(data);
[max_l,sigma]= log_likelihood(min_sq_err,N);

end