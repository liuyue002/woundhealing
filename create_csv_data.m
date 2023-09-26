for experiment = 1:8
    if ismember(experiment,[1,2,5,6])
        load(sprintf('simulations/kevindata_circle_xy%d_20220405_raw.mat',experiment),'density');
    else
        load(sprintf('simulations/kevindata_triangle_xy%d_20220405_raw.mat',experiment),'density');
    end
    for i=1:77
        A=density(:,:,i);
        writematrix(A,sprintf('csv_data/xy%d/t%.3d.csv',experiment,i));
    end
end