% Add the path to the folder containing necessary plotting functions
addpath('../For_Plot/')

% Load data from a MATLAB file containing crust model data
load('../../Crust_Model/Ant_Crust.mat')

% Define the x and y coordinate ranges and create a grid
x = -3330000:20000:3330000;
y = -3330000:20000:3330000;
[X, Y] = meshgrid(x, y);

% Create a mask to filter data; here, it seems to filter based on a threshold in MeanSSB_th
mask = MeanSSB_th - MeanSSB_th + 1;
mask(MeanSSB_th < 10) = nan; % Setting values below 10 to NaN

% Define a gray color for later use
grayColor = [.3 .3 .3];

% Define contour levels for the first plot
axsse = 1:2:10;
axsse = [axsse, 2];

% Create the first plot for the sediment thickness (MeanSSB_th)
% This function `ant_plot_4ss` is presumably a custom function for plotting the data
ax = ant_plot_4ss(x, y, 1, MeanSSB_th .* mask / 1000, [0 8], 'L17', 'km', 'b)', 1, 0.7);
hold on

% Add contour lines to the first plot and label specific contours
[C, h] = contour(ax, X, Y, MeanSSB_th / 1000, axsse, 'LineColor', 'k');
v = [1, 3, 5];
clabel(C, h, v, 'FontSize', 6, 'Color', 'w', 'FontSmoothing', 'on');

% Define contour levels for the second plot
axsse = -20:-2:-60;

% Create the second plot for the Moho depth (MeanMoho)
ax = ant_plot_4ss(x, y, 1, MeanMoho / 1000, [-60 -10], 'L16', 'km', 'b)', 2, 0.7);
hold on

% Add contour lines to the second plot and label specific contours
[C, h] = contour(ax, X, Y, MeanMoho / 1000, axsse, 'LineColor', 'k');
v = [-20, -30, -40, -50];
clabel(C, h, v, 'FontSize', 6, 'Color', 'k', 'FontSmoothing', 'on');

% Create the third plot for mean crust density (MeanCrust_den)
ant_plot_4ss(x, y, 1, MeanCrust_den * 1e3, [2750 2950], nan, 'kg m^{-3}', 'b)', 3, 0.7);

% Create the fourth plot for the base of the lithospheric mantle (MeanBase)
ant_plot_4ss(x, y, 1, MeanBase * 1e3, [3250 3350], nan, 'kg m^{-3}', 'b)', 4, 0.7);

% Save the generated figures in PNG and PDF formats with high resolution
print(gcf, "Figure_2.png", '-dpng', '-r600');
print(gcf, "Figure_2.pdf", '-dpdf', '-r600');
