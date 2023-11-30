addpath('../For_Plot/')
clc
clear
% 
[AP,APP]= geotiffread('../../Initial_model/FAA_C.tif');

% ant_plot_4([APP.XWorldLimits(1),APP.XWorldLimits(2)],[APP.YWorldLimits(1),APP.YWorldLimits(2)],1,flipud(AP),[-150 150],'D01A','mGal','b)',3)

[A,R] = geotiffread('../../Initial_model/ANTGG_FreeAirGravityAnomaly_10km.tif');

A = imread('../../Initial_model/ANTGG_FreeAirGravityAnomaly_10km.tif');
A(A<-1e3)=nan;
A=double(A);
x=R.XWorldLimits(1)+R.CellExtentInWorldX/2:R.CellExtentInWorldX:R.XWorldLimits(2)-R.CellExtentInWorldX/2;
y=R.YWorldLimits(1)+R.CellExtentInWorldY/2:R.CellExtentInWorldY:R.YWorldLimits(2)-R.CellExtentInWorldY/2;


f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 16 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.075 0.45 0.920]
ant_plot_2ss(x,y,ax,flipud(A),[-150,150],'D01A','mGal','a)',1)


ax = subplot(1,2,2)
ax.Position = [0.50 0.075 0.45 0.920]


ant_plot_2ss([APP.XWorldLimits(1),APP.XWorldLimits(2)],[APP.YWorldLimits(1),APP.YWorldLimits(2)],ax,flipud(AP),[-150 150],'D01A','mGal','b)',2)

print(gcf,"C3_SP1.png",'-dpng','-r300')
