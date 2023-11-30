addpath('../For_Plot/')
clc
clear

% LoadMoho
Moho = ncread("../../Initial_model/ST2_Moho.nc",'Moho');
Mohox = ncread("../../Initial_model/ST2_Moho.nc",'x');
Mohoy = ncread("../../Initial_model/ST2_Moho.nc",'y');

% Load Input gravity after removing longwavelength
faa = ncread("../../Initial_model/ST2_faa.nc",'faa');

faax = ncread("../../Initial_model/ST2_faa.nc",'x');
faay = ncread("../../Initial_model/ST2_faa.nc",'y');

df = readtable("../../Initial_model/Initial_Seismic.csv");

cf = readtable("../../Initial_model/Control_Seismic.csv");
% Load Combined Gravity
[AP,APP]= geotiffread('../../Initial_model/FAA_C.tif');

% Load ANTGG
[A,R] = geotiffread('../../Initial_model/ANTGG_FreeAirGravityAnomaly_10km.tif');

A = imread('../../Initial_model/ANTGG_FreeAirGravityAnomaly_10km.tif');
A(A<-1e3)=nan;
A=double(A);
x=R.XWorldLimits(1)+R.CellExtentInWorldX/2:R.CellExtentInWorldX:R.XWorldLimits(2)-R.CellExtentInWorldX/2;
y=R.YWorldLimits(1)+R.CellExtentInWorldY/2:R.CellExtentInWorldY:R.YWorldLimits(2)-R.CellExtentInWorldY/2;



ax = ant_plot_4ss(x, y, 1, flipud(A), [-150,150], 'D01A', 'mGal', 'a)', 1, nan);
ax = ant_plot_4ss([APP.XWorldLimits(1),APP.XWorldLimits(2)],[APP.YWorldLimits(1),APP.YWorldLimits(2)], 1, flipud(AP),[-150 150], 'D01A','mGal', 'b)', 2, nan);
ax = ant_plot_4ss(faax*1e3,faay*1e3,1,faa',[-150,150],'D01A','mGal','c)', 3, nan);
ax = ant_plot_4ss(Mohox*1e3,Mohoy*1e3,ax,-Moho',[-60,-10],'L16','km','d)', 4, nan);

hold on

scatter(df.X,df.Y,15,-df.Input,'filled','MarkerEdgeColor', 'k')
caxis([-60,-10])
hold on
scatter(cf.X,cf.Y,5,cf.X-cf.X-70,'filled','MarkerEdgeColor', 'k')

print(gcf,"Fig_S1.png",'-dpng','-r300')

