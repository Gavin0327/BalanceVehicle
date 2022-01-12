function a2l_disp(name, units, min, max, datatype, desc_s)
if nargin < 6
    error('Usage: a2l_disp(name, units, min, max, datatype, description)');
end
temp = STM32.Signal; 
temp.RTWInfo.StorageClass = 'Custom';
temp.RTWInfo.CustomStorageClass = 'R_Global'; 
try
    temp.DataType = datatype;
catch
    disp([ datatype ' is not a valid datatype.'])
end
if ~strcmp('Enum',datatype(1:4)) &&...
        ~strcmp('boolean', datatype) &&...
        ~strcmp('Bus', datatype(1:3))
    if isstr(min)
        if strcmp(datatype, 'single')
            temp.Min = -realmax('single');
        elseif strcmp(datatype, 'double')
            temp.Min = -realmax('double');
        else
            temp.Min = intmin(datatype);
        end
    else
        temp.Min = min;
    end
    
    if isstr(max)
        if strcmp(datatype, 'single')
            temp.Max = realmax('single');
        elseif strcmp(datatype, 'double')
            temp.Max = realmax('double');
        else
            temp.Max = double(intmax(datatype));
        end
    else
        temp.Max = max;
    end
end

temp.DocUnits = units;
temp.Description = desc_s;
temp.Complexity = 'real';
temp.Dimensions = 1;

[match_flg, error_s, feature_s] = check_item_name(name);

%if match_flg
    %temp.RTWInfo.CustomAttributes.DefinitionFile = [feature_s '_var'];
%else
%    disp(['WARNING: a2l_disp - ' name ' does not match project naming convention - ' error_s])
%end

assignin('base', name, temp)

if length(name) > 31 %31
    warning(['Name ' name ' exceeds maximum allowable length.'])
end

