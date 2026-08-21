data.Properties.VariableNames = lower(data.Properties.VariableNames);

for i = 1:width(data)
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'__','');
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'ppm_','ppm');
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'ppb_','ppb');
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'ppt_','ppt');
    
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'ma_','ma');
    data.Properties.VariableNames{i} = replace(data.Properties.VariableNames{i},'ka_','ka');
end