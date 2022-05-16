function [zs] = interp_zero(x,y)
%Find approximate roots of y=f(x) using linear interpolation
% x,y provided as row vector
n = size(x,2);
zs=[];
for i=1:n-1
    x1=x(i);
    y1=y(i);
    x2=x(i+1);
    y2=y(i+1);
    if sign(y1) ~= sign(y2)
        m=(y2-y1)/(x2-x1);
        z=x1-y1/m;
        zs=[zs,z];
    end
end
end

