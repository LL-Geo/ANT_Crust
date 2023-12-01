addpath('../For_Plot/')
clc
clear

% For plot

xx = -3330000:20000:3330000;
yy = -3330000:20000:3330000;
[XX, YY] = meshgrid(xx, yy);

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

% Load data

load('../../Geochem_data/PetroChron_bin_20km.mat')
% A=readtable('PetroChron.csv');
HP_petro=PetroChron_bin(:,3);
Den_petro=PetroChron_bin(:,4);
Count_petro=PetroChron_bin(:,5);

% HP_petro=A.heat_production;
x=PetroChron_bin(:,1);
y=PetroChron_bin(:,2);

% Modelled Heat Production
load('../../Crust_Model/Ant_Crust.mat')
Den_INV1=log10(reshape(Mean_Hete_den(:,:,6)*1e3,334*334,1));

HPD_INV1c = c_50(Den_INV1);
HPD_INV1c=reshape(HPD_INV1c,334,334);
hp_inv_interp=interp2(XX,YY,10.^(HPD_INV1c),x,y);
den_inv_interp=interp2(XX,YY,Mean_Hete_den(:,:,6)*1e3,x,y);


ant_plot_4ss(xx, yy, 1, XX-XX+nan, [0 3], nan, 'µW m^{-3}', 'c)', 1, nan);
hold on
scatter(x,y,8,HP_petro,'filled')
caxis([0,3])

ant_plot_4ss(xx, yy, 1, XX-XX+nan, [0 3], nan, 'µW m^{-3}', 'c)', 2, nan);
hold on
scatter(x,y,8,hp_inv_interp,'filled')
caxis([0,3])

ant_plot_4ss(xx, yy, 1, XX-XX+nan, [-2 2], 'D01A', 'µW m^{-3}', 'c)', 3, nan);
hold on
scatter(x,y,8,hp_inv_interp-HP_petro,'filled')
caxis([-2,2])
%colorcet('D01A')

ant_plot_4ss(xx, yy, 1, XX-XX+nan, [0 20], nan, 'number', 'c)', 4, nan);
hold on
scatter(x,y,8,Count_petro,'filled')
caxis([0,20])

print(gcf, "Fig_S11_1.png", '-dpng', '-r600')

mis_hp=hp_inv_interp-HP_petro;
mis_den=den_inv_interp-Den_petro;


f=figure()
u = f.Units;
f.Units = 'centimeters';
f.Position=[0 0 17 7.5];

ax = subplot(1,2,1)
ax.Position = [0.05 0.08 0.45 0.915]
nhist(mis_hp)
ax.XLabel.String = {'misfit';'µW m^{-3}'};
ax.XLabel.Position(1) = -4;
ax.XLabel.Position(2) = 40;
ax.YLabel.Position(1) = -7;
 
pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','e)','FitBoxToText','off');

ax = subplot(1,2,2)
ax.Position = [0.55 0.08 0.45 0.915]

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07,0.07/2,0.07-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','f)','FitBoxToText','off');
nhist(mis_den)

ax.XLabel.String = {'misfit';'kg m^{-3}'};
ax.XLabel.Position(1) = -500;
ax.XLabel.Position(2) = 20;
ax.YLabel.Position(1) = -500;
print(gcf, "Fig_S11_2.png", '-dpng', '-r600')
