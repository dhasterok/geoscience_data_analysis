addpath ~/'Google Drive'/heat_production/codes/worldgrid/

[elon,elat,etopo2] = worldgrid('etopo2');

lon = [-180+2.5:5:180-2.5];
lat = [-180+2.5:5:180-2.5];

% Initialize matrix to store average elevations
avg_elevation = NaN(length(lat)-1, length(lon)-1);

for i = 1:length(lat)-1
    for j = 1:length(lon)-1
        % Find indices for the current 5-degree bin
        lat_idx = find(lat >= lat(i) & lat < lat(i+1));
        lon_idx = find(lon >= lon(j) & lon < lon(j+1));
        
        if ~isempty(lat_idx) && ~isempty(lon_idx)
            % Extract the subset of the topography matrix for the current bin
            topo_subset = topo(lat_idx, lon_idx);
            
            % Calculate the average elevation for the current bin
            avg_elevation(i, j) = mean(topo_subset(:), 'omitnan');
        end
    end
end

% Plot the average elevation map
figure;
imagesc(lon_centers, lat_centers, avg_elevation);
set(gca, 'YDir', 'normal');  % Correct the direction of the y-axis
colorbar;
xlabel('Longitude');
ylabel('Latitude');
title('Average Elevation Every 5 Degrees');
