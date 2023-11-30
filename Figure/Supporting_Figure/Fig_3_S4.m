addpath('../For_Plot/')
clc
clear
x = ncread("../../Initial_model/misfit_check.nc",'x');
y = ncread("../../Initial_model/misfit_check.nc",'y');
Man = ncread("../../Initial_model/misfit_check.nc",'Man');
Moho = ncread("../../Initial_model/misfit_check.nc",'Moho');
Crust = ncread("../../Initial_model/misfit_check.nc",'Crust');
Man_Moho = ncread("../../Initial_model/misfit_check.nc",'Man_Moho');

x=x*1e3;
y=y*1e3;
ant_plot_4ss(x,y,1,Man',[-250 250],'D01A','mGal','b)',1,0.7)
ant_plot_4ss(x,y,1,Moho',[-250 250],'D01A','mGal','b)',2,0.7)
ant_plot_4ss(x,y,1,Crust',[-250 250],'D01A','mGal','b)',3,0.7)
ant_plot_4ss(x,y,1,Man_Moho',[-250 250],'D01A','mGal','b)',4,0.7)
print(gcf,"Fig_S4.png",'-dpng','-r300')
