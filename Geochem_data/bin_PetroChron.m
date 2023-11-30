% Clear the command window and workspace
clc
clear

% Read the data from a CSV file into a table
A = readtable('PetroChron.csv');

% Extract various columns from the table for processing
Den_petro = A.density_model;
HP_petro = A.heat_production;
HP_density = A.density_model;
HP_by_mass = A.heat_production_mass;

% Define a range of data points for plotting
XX = -3330000:20000:3330000;
YY = -3330000:20000:3330000;
[XX, YY] = meshgrid(XX, YY);

% Convert latitude and longitude to polar stereographic coordinates
[x, y] = ll2ps(A.latitude, A.longitude);

% Combine the converted coordinates into a single matrix
XY = [x, y];

% Define minimum and maximum coordinates for mapping
mn = [-3340000 -3340000]; mx = [3340000 3340000];
N = 334;
edges = linspace(mn(1), mx(1), N+1);

% Map points to bins based on the defined edges
[~, subs] = histc(XY, edges, 1);
subs(subs == N+1) = N;

% Create a 2D histogram of bins count
H = accumarray(subs, 1, [N N]);

% Calculate median heat production and density for each bin
Hs = accumarray(subs, HP_petro, [N N], @median);
Hd = accumarray(subs, HP_density, [N N], @median);

% Create a mask for non-empty bins
Mask = Hs - Hs + 1;
Mask(H <= 0) = nan;

% Apply the mask to the coordinate and data matrices
Hss_x = XX .* Mask;
Hss_y = YY .* Mask;
Hss_h = Hs .* Mask;
Hss_d = Hd .* Mask;
Hss_c = H .* Mask;

% Reshape and combine the data for export
PetroChron_bin = [reshape(Hss_y, 334*334, 1), reshape(Hss_x, 334*334, 1), reshape((Hss_h), 334*334, 1), reshape((Hss_d), 334*334, 1), reshape((Hss_c), 334*334, 1)];
PetroChron_bin = PetroChron_bin(sum(isnan(PetroChron_bin), 2) == 0, :);

% Save the processed data to a .mat file
save PetroChron_bin_20km.mat PetroChron_bin

% Plot the data using a scatter plot
figure()
subplot(1,2,1)
scatter(reshape(Hss_y, 334*334, 1), reshape(Hss_x, 334*334, 1), [], reshape((Hss_h), 334*334, 1), 'filled')
caxis([0, 3])
colorbar
subplot(1,2,2)
scatter(reshape(Hss_y, 334*334, 1), reshape(Hss_x, 334*334, 1), [], reshape((Hss_c), 334*334, 1), 'filled')
caxis([0, 20])
colorbar
