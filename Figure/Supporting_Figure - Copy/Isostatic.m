clc
clear 


load('../../Crust_Model/Ant_Crust.mat')


% Load Data
x=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','x');
y=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','y');
mask=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','mask');
thickness=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','thickness');
bed=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','bed');
surface=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','surface');
% source=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','source');
% errbed=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','errbed');
geoid=ncread('X:\Antarctica\bedmachine\BedMachineAntarctica_2019-11-05_v01.nc','geoid');


Sx=double(x(7:40:end));
Sy=double(y(7:40:end));
Smask=double(mask(7:40:end,7:40:end))';
Sthickness=double(thickness(7:40:end,7:40:end))';
Sbed=double(bed(7:40:end,7:40:end))';
Ssurface=double(surface(7:40:end,7:40:end))';
Sgeoid=double(geoid(7:40:end,7:40:end))';



[XX,YY]=meshgrid(Sx,Sy);

%Water thickness
wmask=Smask;
wmask(wmask<4)=0;
Waterthickness=(Ssurface-Sbed-Sthickness).*(wmask/4);
%Sea thickness
seamask=(Smask+1)./(Smask+1)-1;
seamask(Smask==0 | Smask==3)=1;
Seathickness=(Ssurface-Sbed-Sthickness).*seamask;


%filter
h = 1/3*ones(3,1);
H = h*h';
FSsurface= filter2(H,Ssurface);
FSthickness= filter2(H,Sthickness);
FSeathickness= filter2(H,Seathickness);
FSbed= filter2(H,Sbed);

Rock=MeanSSB_th.*MeanSSB_den;
Rock(isnan(Rock))=0;
Rock=MeanCrust_den.*MeanCrust_th+Rock;
Mass=FSthickness*0.917+FSeathickness.*1.03+flipud(Rock);

Density_c=MeanBase-MeanCrust_den;
Moho_geo=Mass./flipud(Density_c);

Diff=flipud(MeanMoho)-mean(mean(MeanMoho))-Moho_geo;
