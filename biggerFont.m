function [ ] = biggerFont( figg, varargin)
%Makes all text in figure bigger and lines thicker for publication
fontsize=18;
if size(varargin)>=1
    fontsize=varargin{1};
end
drawnow;
axs=figg.Children;
for i=1:length(axs)
    ax=axs(i);
    set(ax,'FontSize', fontsize);
    set(findall(ax, 'Type', 'Line'),'LineWidth',2);
end
end