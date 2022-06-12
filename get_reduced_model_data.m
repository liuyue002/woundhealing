function [cc] = get_reduced_model_data(params,numeric_params,t_skip,x_skip,dim,ic,xs)
%Get simulation data from model, taking only certain slices, arranged as a
%1D vector
%   params,numeric_params: parameters for the simulation
%   t_skip, x_skip: how many time/space points to skip
%   dim: either 1 (1D sim) or 2 (2D sim)
%   ic: initial condition (can be NaN)
%   xs: for radial 1D case
if dim==1
    [~,cc,~] = woundhealing_1d(params,numeric_params,0,ic,xs);
    N=prod(ceil(size(cc)./[t_skip,x_skip]));
    cc=cc(1:t_skip:end,1:x_skip:end);
    cc=reshape(cc,N,1);
else
    [~,cc,~] = woundhealing_2d(params,numeric_params,0,ic);
    N=prod(ceil(size(cc)./[t_skip,x_skip,x_skip]));
    cc=cc(1:t_skip:end,1:x_skip:end,1:x_skip:end);
    cc=reshape(cc,N,1);
end
end

