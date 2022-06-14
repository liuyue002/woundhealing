function [fig] = animate_2var_1d(uu,vv,xlimit,Dt,uname,vname,prefix,makegif)
%Animate a function u(x,t) of time and 1D space
% uu(i,j) = u(x_j,t_i)
% xlimit: the 1D domain, i.e. [0,L]
% Dt: time step between each frame
% uname, vnam: name of the function (i.e. 'u' and 'v')
% prefix: prefix for saving any file
% whether to save gif
[nFrame,nx]=size(uu);
xs=linspace(xlimit(1),xlimit(2),nx);
ts=(0:1:nFrame)*Dt;
T=nFrame*Dt;
fig=figure('Position',[10 100 1000 500],'color','w');
hold on;
xlabel('x');
ylabel([uname,',',vname]);
xlim(xlimit);
ylim([0,max(uu,[],'all')*1.1]);
cfig1=plot(xs,uu(1,:));
cfig2=plot(xs,vv(1,:));
figtitle=title('t=0');
legend(uname,vname);
if makegif
    giffile=[prefix,'.gif'];
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    imwrite(imind,cm,giffile,'gif', 'Loopcount',inf);
end
for iframe=1:nFrame
    cfig1.YData=uu(iframe,:);
    cfig2.YData=vv(iframe,:);
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

