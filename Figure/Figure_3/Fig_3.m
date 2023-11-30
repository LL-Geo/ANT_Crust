addpath('../For_Plot/')
clc
clear

% Read data from a CSV file
A = readtable('../../Geochem_data/Whole_rock.csv');

% Calculate logarithms of some columns
Density = log10(A.density_model);
Heat_Production = log10(A.heat_production);
Heat_Production_mass = log10(A.heat_production_mass);

h = histogram2(Density, Heat_Production, [100, 500], 'FaceColor', 'flat', 'DisplayStyle', 'tile');
S = h.Values;

% Calculate cumulative sums and percentiles
Scont = zeros(100, 500);
for i = 1:500
    Scont(:, i) = sum(S(:, 1:i), 2);
end

SS = sum(S, 2);
SS = repmat(SS, 1, 500);

Q_25 = SS * 0.25;
Q_75 = SS * 0.75;
Q_50 = SS * 0.50;

[Q_25a, Q_25b] = min(abs(Scont - Q_25), [], 2);
[Q_75a, Q_75b] = min(abs(Scont - Q_75), [], 2);
[Q_50a, Q_50b] = min(abs(Scont - Q_50), [], 2);

HPD25 = (h.YBinEdges(Q_25b) + h.YBinEdges(Q_25b + 1)) / 2;
HPD75 = (h.YBinEdges(Q_75b) + h.YBinEdges(Q_75b + 1)) / 2;
HPD50 = (h.YBinEdges(Q_50b) + h.YBinEdges(Q_50b + 1)) / 2;

Den = h.XBinEdges(1:end-1);
Den = Den + (Den(2) - Den(1)) / 2;

% Filter out values outside a specific range
Den(Den < log10(2650)) = nan;
Den(Den > log10(2955)) = nan;

Den_check = exp(Den);
Den_fit = Den;
Den_fit(isnan(Den)) = [];

HPD_25_fit = HPD25;
HPD_25_fit(isnan(Den)) = [];
HPD_50_fit = HPD50;
HPD_50_fit(isnan(Den)) = [];
HPD_75_fit = HPD75;
HPD_75_fit(isnan(Den)) = [];

% Fit polynomial curves
c_25 = fit(Den_fit', HPD_25_fit', 'poly1');
c_50 = fit(Den_fit', HPD_50_fit', 'poly1');
c_75 = fit(Den_fit', HPD_75_fit', 'poly1');
c_50_s = fitlm(Den_fit', HPD_50_fit', 'poly1');


load('../../Crust_Model/Ant_Crust.mat')

Den_INV1=log10(reshape(Mean_Hete_den(:,:,6)*1e3,334*334,1));

HPD_INV1c = c_50(Den_INV1);
HPD_INV1c=reshape(HPD_INV1c,334,334);
HPD_INV1c_U = c_75(Den_INV1);
HPD_INV1c_U=reshape(HPD_INV1c_U,334,334);
HPD_INV1c_D = c_25(Den_INV1);
HPD_INV1c_D=reshape(HPD_INV1c_D,334,334);

[map2, descriptorname, description] = colorcet('L16');


la=-85:5:-50;
lon=0:1:360;
la2=-90:5:-50;
lon2=0:30:360;
[la,lon]=meshgrid(la,lon);
[lon2,la2]=meshgrid(lon2,la2);

[xt,yt]=ll2ps(la,lon);
[xt2,yt2]=ll2ps(la2,lon2);
grayColor = [.7 .7 .7];


f=figure()
u = f.Units;
f.Units = 'centimeters';


f.Position=[0 0 15 21];

edgx=0.03;
edgy=0.015;
n=3;
m=2;

% mask_A=A-A+1;

ax = subplot(3,2,1)
ax.Position = [edgx edgy+2/n 1/m-2*edgx 1/n-edgy]
A=Mean_Hete_den(:,:,6);
A(A==A(1,1))=nan;
mask_A=A-A+1;

ant_plotss(ax,A*1e3,[2650,2850],nan,'kg m^{-3}','a)')


ax = subplot(3,2,2)
ax.Position = [1/m+edgx edgy+2/n 1/m-2*edgx 1/n-edgy]
A=MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[0,30],nan,'km','b)')

ax = subplot(3,2,3)
ax.Position = [edgx edgy+1/n 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV1c)).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[0,50],'L16','mW m^{-2}','c)')

ax = subplot(3,2,4)
ax.Position = [1/m+edgx edgy+1/n 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV1c)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','d)')

ax = subplot(3,2,5)
ax.Position = [edgx edgy 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV1c_U)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','e)')

ax = subplot(3,2,6)
ax.Position = [1/m+edgx edgy 1/m-2*edgx 1/n-edgy]

A=(10.^(HPD_INV1c_D)-1).*MeanCrust_th/2000;
A=A.*mask_A;
ant_plotss(ax,A,[-50,50],'D01A','mW m^{-2}','f)')

print(gcf,"Figure_3.png",'-dpng','-r600')
print(gcf,"Figure_3.pdf",'-dpdf','-r600')



