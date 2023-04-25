%% changing dt

load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_220644_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.067,dx=29.200,.mat','cc');
cc0=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203242_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=29.200,.mat','cc');
cc1=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203352_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.017,dx=29.200,.mat','cc');
cc2=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203650_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.008,dx=29.200,.mat','cc');
cc3=cc;
N=77*150*150;

disp(sum(abs(cc0-cc3),'all')/N);
disp(sum(abs(cc1-cc3),'all')/N);
disp(sum(abs(cc2-cc3),'all')/N);

%% changing dx

load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_203242_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=29.200,.mat','cc');
cc1=cc;
load('/home/liuy1/Documents/woundhealing/simulations/woundhealing_2d_numerics_test_20230326_222017_circle_D0=1300,r=0.3,alpha=1,beta=1,gamma=1,n=0,k=2600.0,dt=0.033,dx=14.600,.mat','cc')
cc2=cc;
cc2=cc2(:,1:2:end,1:2:end);
disp(sum(abs(cc1-cc2),'all')/N);