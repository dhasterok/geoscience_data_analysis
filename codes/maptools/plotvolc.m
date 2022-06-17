function varargout = plotvolc(size)
% PLOTVOLC - plots locations of holocene and quaternary volcnoes
volc.holo = readtable('../GIS/volcanoes/GVP_Volcano_List_Holocene.csv', ...
    'Format','%f%q%q%q%q%q%q%q%f%f%f%q%q%q');
volc.pleist = readtable('../GIS/volcanoes/GVP_Volcano_List_Pleistocene.csv', ...
    'Format','%f%q%q%q%q%q%q%q%f%f%f%q%q%q');
volc.possible = readtable('../GIS/volcanoes/possible_volcanic_centers.csv', ...
    'Format','%f%q%q%q%q%q%q%q%f%f%f%q%q%q');

C = [0    0.8    0;
   0.8500    0.3250    0.0980;
   0    0.4470    0.7410;
   0.4940    0.1840    0.5560];

setting = unique(volc.holo.TectonicSetting);
for i = 2:length(setting)
    ind = strcmp(volc.pleist.TectonicSetting,setting{i});
    s(i-1) = scatter(volc.pleist.Longitude(ind),volc.pleist.Latitude(ind),'^');
    set(s(i-1),'SizeData',size,'CData',C(i-1,:));
    hold on;
    
    ind = strcmp(volc.holo.TectonicSetting,setting{i});
    s2(i-1) = scatter(volc.holo.Longitude(ind),volc.holo.Latitude(ind),'^','filled');
    set(s2(i-1),'SizeData',size,'CData',C(i-1,:));
    
    ind = strcmp(volc.possible.TectonicSetting,setting{i});
    s3(i-1) = scatter(volc.possible.Longitude(ind),volc.possible.Latitude(ind),'^');
    set(s3(i-1),'SizeData',size,'CData',C(i-1,:));
end

legend(s,setting(2:end),'Location','north','Orientation','horizontal');

if nargout == 1
    volc.holo.age = cell([height(volc.holo) 1]);
    volc.holo.age(:) = {'Holocene'};
    volc.pleist.age = cell([height(volc.pleist) 1]);
    volc.pleist.age(:) = {'Pleistocene'};
    volc.possible.age = cell([height(volc.possible) 1]);
    volc.possible.age(:) = {'Unknown'};
    
    varargout{1} = [volc.holo; volc.pleist; volc.possible];
end

return