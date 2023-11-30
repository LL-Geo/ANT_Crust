addpath('../For_Plot/')
clc
clear

% Read data from a CSV file
A = readtable('../../Geochem_data/Whole_rock.csv');

% Calculate logarithms of some columns
Density = log10(A.density_model);
Heat_Production = log10(A.heat_production);
Heat_Production_mass = log10(A.heat_production_mass);

% Create a figure with specified dimensions
f = figure();
f.Units = 'centimeters';
f.Position = [0 0 16 16];

% Define subplot layout parameters
edgx = 0.075;
edgy = 0.05;
n = 2;
m = 2;

% Create the first subplot
ax1 = subplot(2, 2, 1);
ax1.Position = [edgx edgy + 1/n 1/m - edgx 1/n - edgy];
h = histogram2(Density, Heat_Production, [100, 500], 'FaceColor', 'flat', 'DisplayStyle', 'tile');
S = h.Values;

% Add a colorbar
pos2 = plotboxpos(gca);
a = colorbar('west', 'Position', [pos2(1) + 0.03 pos2(2) + 0.01 0.01 0.383989501312336/3.5], 'AxisLocation', 'in');
a.Label.String = 'Np.samples';
a.Label.Position(1) = -3;

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

hold on
hLine=plot(Den,HPD25,'kv','LineWidth',0.3,'MarkerSize',3,'DisplayName','25^{th}')
hold on
hLine2=plot(Den,HPD75,'k^','LineWidth',0.3,'MarkerSize',3,'DisplayName','75^{th}')
hold on
hLine3=plot(Den,HPD50,'kx','LineWidth',0.3,'MarkerSize',3,'DisplayName','Median')



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



hold on
plot(c_25,'k-.')
hold on
plot(c_50,'k-.')
hold on
plot(c_75,'k-.')

legend off
xlabel('log_{10}(density(kg m^{-3}))','Position',[3.475 -2.5])
ylabel('log_{10}(heat producion(µW m^{-3}))')


hold on
plot([3.4232 3.4232],[-3 3],'k--')
hold on
plot([3.4698 3.4698],[-3 3],'k--')

pos3= [pos2(1),pos2(2)+pos2(4)-0.07/2,0.07/2,0.07/2-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','a)','FitBoxToText','off');

ylim([-3,2.1])
yticks([-3:2])

% Create the first subplot
ax2 = subplot(2, 2, 2);
ax2.Position = [1/m + edgx, edgy + 1/n, 1/m - edgx, 1/n - edgy];

% Fill the area between percentiles with a gray color
x2 = [10.^(Den_fit')', fliplr(10.^(Den_fit')')];
inBetween = [10.^(c_25((Den_fit')))', fliplr(10.^(c_75((Den_fit')))')];
grayColor = [0.7 0.7 0.7];
fill(x2, inBetween, grayColor, 'FaceAlpha', 0.3);

% Plot data points and polynomial fits
hold on
hLine = plot(10.^(Den_fit'), 10.^(HPD_25_fit'), 'kv', 'LineWidth', 1);
plot(10.^(Den_fit'), 10.^(c_25((Den_fit'))), 'k-.')
hold on
hLine2 = plot(10.^(Den_fit'), 10.^(HPD_75_fit'), 'k^', 'LineWidth', 1);
plot(10.^(Den_fit'), 10.^(c_75((Den_fit'))), 'k-.')
hold on
hLine3 = plot(10.^(Den_fit'), 10.^(HPD_50_fit'), 'kx', 'LineWidth', 1);
plot(10.^(Den_fit'), 10.^(c_50((Den_fit'))), 'k-.')
xlim([2650 2970])
xlabel('density (kg m^{-3})', 'Position', [2800 0.35])
ylabel('heat production (µW m^{-3})')

% Add a legend
legend([hLine, hLine2, hLine3], '25^{th}', '75^{th}', 'Median')
yticks([0:4])

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07/2,0.07/2,0.07/2-0.001];
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','b)','FitBoxToText','off');

%% 


%%
load('../../Crust_Model/Ant_Crust.mat')
Den_INV1=log10(reshape(Mean_Hete_den(:,:,6)*1e3,334*334,1));

Den_INV1_U=log10(reshape(Mean_Hete_den(:,:,6)*1e3+STDCrust_den*1e3,334*334,1));
Den_INV1_D=log10(reshape(Mean_Hete_den(:,:,6)*1e3-STDCrust_den*1e3,334*334,1));



HPD_INV1c = c_50(Den_INV1);
HPD_INV1c=reshape(HPD_INV1c,334,334);


HPD_MM=10.^(HPD_INV1c);
x=-3330000:20000:3330000;
y=-3330000:20000:3330000;

la=-85:5:-50;
lon=0:1:360;
la2=-90:5:-50;
lon2=0:30:360;
[la,lon]=meshgrid(la,lon);
[lon2,la2]=meshgrid(lon2,la2);

[xt,yt]=ll2ps(la,lon);
[xt2,yt2]=ll2ps(la2,lon2);
grayColor = [.7 .7 .7];


edgx=0.035;
edgy=0.035;

ax = subplot(2,2,3)
ax.Position = [edgx edgy+0/n 1/m-edgx 1/n-edgy]

A=HPD_MM;
A(A==A(1,1))=nan;
h=imagesc(x,y,(A))
caxis([0,3])

set(gca,'YDir','normal')
set(h, 'AlphaData', 1-isnan((A)))
hold on
plot(xt,yt,'Color',  grayColor);
hold on
plot(xt2,yt2,'Color', grayColor);

draw_coastline
axis equal

% 
xlim([-2900000 2900000]) 
ylim([-2900000 2900000]) 

xticks([-2000000  0  2000000])
xticklabels([])
yticks([-2000000  0  2000000])
yticklabels({'120^{\circ}W','90^{\circ}W','60^{\circ}W'})
ytickangle(90)
ax.XRuler.TickLabelGapOffset = -2;  % default = +2
set(gca,'TickLength',[0 0])

ss=500000;
sp=300000;
hold on
plot([2500000-sp 3000000-sp],[3000000.9-ss 3000000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000-sp 2500000-sp],[2950000.9-ss 2950000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000-sp 3000000-sp],[2920000.9-ss 2920000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000-sp 3000000-sp],[3025000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000-sp 2000000-sp],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([3000000-sp 3000000-sp],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 


text(2500000-sp,3400000-ss,'1000 km','horiz','center','vert','top'); 

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07/2,0.07/2,0.07/2-0.001];
a=colorbar('west','Position',...
    [pos2(1)+0.03 pos2(2)+0.01 0.01 0.383989501312336/3.5],...
    'AxisLocation','in');
% set(a.XLabel,{'String','Rotation','Position'},{'µW m^{-3}',0,[0.8 -0.01]})
a.Label.String = 'µW m^{-3}';
a.Label.Position(1) = -3;
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','c)','FitBoxToText','off');
%%

load('../../Geochem_data/PetroChron_bin_20km.mat')
% A=readtable('PetroChron.csv');
HP_petro=PetroChron_bin(:,3);
Den_petro=PetroChron_bin(:,4);

% HP_petro=A.heat_production;
x=PetroChron_bin(:,1);
y=PetroChron_bin(:,2);
% [x,y]=ll2ps(A.latitude,A.longitude);



ax = subplot(2,2,4)
ax.Position = [1/m+edgx edgy+0/n 1/m-edgx 1/n-edgy]

A=HPD_MM;
A(A==A(1,1))=nan;

A=HPD_MM;
A=nan;
h=imagesc(x,y,(A))

set(gca,'YDir','normal')
set(h, 'AlphaData', 1-isnan((A)))
hold on
scatter(x,y,8,HP_petro,'filled')
caxis([0,3])

hold on
plot(xt,yt,'Color',  grayColor);
hold on
plot(xt2,yt2,'Color', grayColor);

draw_coastline
axis equal

% 
xlim([-2900000 2900000]) 
ylim([-2900000 2900000]) 


xticks([-2000000  0  2000000])
xticklabels([])
yticks([-2000000  0  2000000])
yticklabels({'120^{\circ}W','90^{\circ}W','60^{\circ}W'})
ytickangle(90)
ax.XRuler.TickLabelGapOffset = -2;  % default = +2
set(gca,'TickLength',[0 0])

ss=500000;
sp=300000;
hold on
plot([2500000-sp 3000000-sp],[3000000.9-ss 3000000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000-sp 2500000-sp],[2950000.9-ss 2950000.9-ss],'k-','linewidth',1.8); 
hold on
plot([2000000-sp 3000000-sp],[2920000.9-ss 2920000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000-sp 3000000-sp],[3025000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([2000000-sp 2000000-sp],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 
hold on
plot([3000000-sp 3000000-sp],[2920000.9-ss 3025000.9-ss],'k-','linewidth',0.2); 


text(2500000-sp,3400000-ss,'1000 km','horiz','center','vert','top'); 

pos2 = plotboxpos(gca);
pos3= [pos2(1),pos2(2)+pos2(4)-0.07/2,0.07/2,0.07/2-0.001];
a=colorbar('west','Position',...
    [pos2(1)+0.03 pos2(2)+0.01 0.01 0.383989501312336/3.5],...
    'AxisLocation','in');
a.Label.String = 'µW m^{-3}';
a.Label.Position(1) = -3;
annotation('rectangle',pos3,'FaceColor','white')
annotation('textbox',pos3,'String','d)','FitBoxToText','off');

print(gcf, "Figure_1.pdf", '-dpdf', '-r600')
print(gcf, "Figure_1.png", '-dpng', '-r600')

