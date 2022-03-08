function [cc] = get_reduced_model_data(T,params,t_skip,x_skip,dim)
%Get simulation data from model, taking only certain slices, arranged as a
%1D vector
%   T: simulation end time
%   params: model parameters
%   t_skip, x_skip: how many time/space points to skip
%   dim: either 1 (1D sim) or 2 (2D sim)
if dim==1
    [~,cc,~] = woundhealing_1d(params,T,0);
    N=prod(ceil(size(cc)./[t_skip,x_skip]));
    cc=cc(1:t_skip:end,1:x_skip:end);
    cc=reshape(cc,N,1);
else
    [~,cc,~] = woundhealing_2d(params,T,0);
    N=prod(ceil(size(cc)./[t_skip,x_skip,x_skip]));
    cc=cc(1:t_skip:end,1:x_skip:end,1:x_skip:end);
    cc=reshape(cc,N,1);
end
end

