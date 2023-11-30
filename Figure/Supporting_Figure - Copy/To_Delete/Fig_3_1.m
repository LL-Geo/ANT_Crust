addpath('../For_Plot/')
clc
clear
Moho = ncread("../../Initial_model/ST2_Moho.nc",'Moho');
Mohox = ncread("../../Initial_model/ST2_Moho.nc",'x');
Mohoy = ncread("../../Initial_model/ST2_Moho.nc",'y');

faa = ncread("../../Initial_model/ST2_faa.nc",'faa');

faax = ncread("../../Initial_model/ST2_faa.nc",'x');
faay = ncread("../../Initial_model/ST2_faa.nc",'y');

df = readtable("../../Initial_model/Initial_Seismic.csv");

cf = readtable("../../Initial_model/Control_Seismic.csv");



f=figure()
u = f.Units;
f.Units = 'centimeters';

% f.Position=[700 650 700 650];
% f.Position=[700/2 650/2 700/2 650/2];
f.Position=[0 0 16 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.075 0.45 0.920]
ant_plot_2(faax*1e3,faay*1e3,ax,faa',[-150,150],'D01A','mGal','a)',1)


ax = subplot(1,2,2)
ax.Position = [0.50 0.075 0.45 0.920]

ant_plot_2(Mohox*1e3,Mohoy*1e3,ax,-Moho',[-60,-10],'L16','km','b)',2)
hold on

scatter(df.X,df.Y,15,-df.Input,'filled','MarkerEdgeColor', 'k')
caxis([-60,-10])
hold on
scatter(cf.X,cf.Y,5,cf.X-cf.X-70,'filled','MarkerEdgeColor', 'k')
% caxis([-60,-10])

print(gcf,"C3_F1.png",'-dpng','-r300')

