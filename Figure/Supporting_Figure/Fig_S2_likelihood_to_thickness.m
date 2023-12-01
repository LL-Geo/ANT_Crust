addpath('../For_Plot/')
clc
clear
like=csvread('../../Initial_model/basin_likelihood_thickness.csv');

th=like(:,4);
th(th<=0)=nan;


likelihood=like(:,5);
likelihood(isnan(th))=[];
th(isnan(th))=[];


plot(likelihood,th,'.')


Q=[likelihood,th];

[xmid,sss]=heatscatter(Q(:,1),Q(:,2),'','40');

c = fit(xmid,sss,'poly3');


ssblike=loadAsciiM('../../Initial_model/basin_likelihood.txt');
ssblike(ssblike==-9999)=nan;

ssb_th=c(ssblike);

ssb_th=reshape(ssb_th,667,667);

ssb_th(ssblike<=0.4)=0;

RIS=loadAsciiM('../../Initial_model/RIS_Basin.txt');

newSSB=RIS;

newSSB(RIS==-9999)=ssb_th(RIS==-9999);

newSSB=newSSB(1:2:end,1:2:end);

Off_sedi=loadAsciiM('../../Initial_model/Offshore_Basin.txt');

Off_sedi(Off_sedi==-9999)=0;

RIS=RIS(1:2:end,1:2:end);

Off_sedi(RIS>-9999)=RIS(RIS>-9999);

All=Off_sedi;

All(Off_sedi==0)=newSSB(Off_sedi==0);

All(isnan(All))=0;

% LoadMoho
Moho = ncread("../../Initial_model/ST2_Moho.nc",'Moho');
Mohox = ncread("../../Initial_model/ST2_Moho.nc",'x');
Mohoy = ncread("../../Initial_model/ST2_Moho.nc",'y');


[A,R] = geotiffread('../../Initial_model/Initial_basin_thickness.tif');
x=R.XWorldLimits(1)+R.CellExtentInWorldX/2:R.CellExtentInWorldX:R.XWorldLimits(2)-R.CellExtentInWorldX/2;
y=R.YWorldLimits(1)+R.CellExtentInWorldY/2:R.CellExtentInWorldY:R.YWorldLimits(2)-R.CellExtentInWorldY/2;
A(A<0)=nan;


ax=ant_plot_4ss(x,y,1,flipud(A/1000),[0 8],'L17','km','b)',1,0.7)

x=-3330000:20000:3330000;
y=-3330000:20000:3330000;


ax=ant_plot_4ss(x,y,1,flipud(ssblike),[0 1],'D01A','','b)',2,0.7)
ax=ant_plot_4ss(x,y,1,flipud(All/1000),[0 8],'L17','km','b)',4,0.7)



edgx=0.05;
edgy=0.05;

ax = subplot(2,2,3)
ax.Position = [edgx+0.01 edgy/1.5+0.04 0.5-edgx-0.01 0.5-edgx-0.04]
[xmid,sss]=heatscatter(Q(:,1),Q(:,2)/1000,'','40');

xlabel('likelihood');
ylabel('km');

fh = gcf();
cbh = findall(fh, 'Type','ColorBar');
    
cbh=cbh(1);
cbh.Location='southoutside';
cbh.Position(1)=0.0595+0.4405/3
cbh.Position(3)=0.4405/3*2

cbh.Position(4)=0.0187
cbh.Position(2)=0.495
cbh.TickDirection='in'
cbh.AxisLocation='in'
pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07/2,0.07/2,0.07/2-0.001];
ax.YRuler.TickLabelGapOffset = -1;
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','c','FitBoxToText','off');

print(gcf,"Fig_S2.png",'-dpng','-r600')

