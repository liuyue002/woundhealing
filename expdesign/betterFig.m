function betterFig(fig,linewidth,fontsize)
%Makes lines thicker and font larger

if ~exist('linewidth','var')
    linewidth = 2;
end
if ~exist('fontsize','var')
    fontsize = 18;
end

if isequal(class(fig.Children),'matlab.graphics.layout.TiledChartLayout')
    % figure made using tiledlayout
    t=fig.Children;
    axs=t.Children;
    for i=1:length(axs)
        ax=axs(i);
        set(ax,'FontSize', fontsize);
        set(findall(ax, 'Type', 'Line'),'LineWidth',linewidth);
    end
    t.TileSpacing = 'tight';
    %t.TileSpacing = 'compact';
    t.Padding = 'none';
elseif isequal(class(fig.Children),'matlab.graphics.axis.Axes')
    % figure made using subplot, or there is only 1 plot
    axs=fig.Children;
    for i=1:length(axs)
        ax=axs(i);
        set(ax,'FontSize', fontsize);
        set(findall(ax, 'Type', 'Line'),'LineWidth',linewidth);
    end
    if length(axs)==1
        ax=axs(1);
        outer = ax.OuterPosition;
        ti = ax.TightInset;
        l = outer(1)+ti(1);
        b = outer(2)+ti(2);
        width = outer(3) - ti(1) - ti(3);
        height = outer(4) - ti(2) - ti(4);
        ax.Position = [l b width height];
    end
elseif isequal(class(fig.Children),'matlab.graphics.primitive.world.Group')
    % the figure has a mix of subplots, legend, and other stuff
    for i=1:length(fig.Children)
        c=fig.Children(i);
        set(c,'FontSize', fontsize);
        if isequal(class(c),'matlab.graphics.axis.Axes')
            set(c,'FontSize', fontsize);
            set(findall(c, 'Type', 'Line'),'LineWidth',linewidth);
        end
    end
end

end