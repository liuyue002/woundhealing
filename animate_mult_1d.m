function [fig] = animate_mult_1d(uus,xlimit,ylimit,Dt,fnames,prefix,makegif)
%Animate a several functions u(x,t) of time and 1D space on the same axis
% uus: a cell array, with
% uus{k}(i,j) = u(x_j,t_i), they must all have same size
% xlimit: the 1D domain, i.e. [0,L]
% ylimit: y axis limit
% Dt: time step between each frame (must be same for all uu)
% fname: cell array of name of the functions (i.e. {'u','v'})
% prefix: prefix for saving any file
% whether to save gif
num_fn = length(uus);
[nFrame,nx]=size(uus{1});
xs=linspace(xlimit(1),xlimit(2),nx);
ts=(0:1:nFrame)*Dt;
fig=figure('Position',[10 100 1000 500],'color','w');
hold on;
xlabel('x');
xlim(xlimit);
ylim(ylimit);
cfig=cell(1,num_fn);
for k=1:num_fn
    cfig{k}=plot(xs,uus{k}(1,:),'DisplayName',fnames{k});
end
figtitle=title('t=0');
legend();
if makegif
    giffile=[prefix,'.gif'];
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
end
for iframe=1:nFrame
    for k=1:num_fn
        cfig{k}.YData=uus{k}(iframe,:);
    end
    figtitle.String=['t=',num2str(ts(iframe),'%.1f')];
    drawnow;
    if makegif
        frame = getframe(fig);
        im = frame2im(frame);
        imind = rgb2ind(im,cm);
        imwrite(imind,cm,giffile,'gif', 'WriteMode','append','DelayTime',0);
    end
end
hold off;

end

