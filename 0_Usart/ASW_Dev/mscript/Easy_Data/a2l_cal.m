function a2l_cal(name, value, units, min, max, data_type, desc_s)
if nargin < 7
    error('Usage: a2l_cal( name, value, units, min, max, data_type, description)');
end
temp = MyPg.Parameter;    
temp.CoderInfo.StorageClass = 'Custom';  
temp.CoderInfo.CustomStorageClass = 'MyConst';  
temp.CoderInfo.CustomAttributes.MemorySection = 'MyRom';
temp.DocUnits = units;
temp.DataType = data_type;
if strcmp(data_type,'single')
    temp.Value = single(value);
elseif strcmp(temp.DataType,'boolean')
    temp.Value=logical(value);
else
    temp.Value = value;
end
% Setting the value can break the datatype. This normally happens if the
% value specified does not match the datatype.
assert(~strcmp(temp.DataType,'auto'));
temp.Description = desc_s;
if ~strcmp(data_type(1:4), 'Enum') && ~strcmp(data_type,'boolean')
    temp.Min = min;
    temp.Max = max;
end

global ena_data_warn
if ena_data_warn
    if length(name) > 31 %31
        warning(['Name ' name ' exceeds maximum allowable length.'])
    end

    [match_flg, error_s, feature_s] = check_item_name(name);

%     if match_flg
%         temp.RTWInfo.CustomAttributes.DefinitionFile = [feature_s '_cal'];
%     
%     else
%         disp(['WARNING: a2l_cal - ' name ' does not match project naming convention - ' error_s])
%     end
end
assignin('base', name, temp);