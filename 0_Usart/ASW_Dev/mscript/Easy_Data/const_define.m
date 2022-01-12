function const_define(name, value, data_type)
%
% function const_define(name, value, data_type)
%
% Creates a constant item definition in the base workspace
% that will give an #define entry in code at build time
%
if nargin < 3
    error('Usage: const_define(name, value, data_type)');
end

if ~evalin('base', 'exist(''opt_no_a2l_cal'', ''var'')')
    temp = mpt.Parameter;
    if strcmp(data_type,'single')
        temp.Value = single(value);
    else
        temp.Value = value;
    end
    temp.RTWInfo.StorageClass = 'Custom';
    %temp.RTWInfo.CustomStorageClass = 'Define';
    temp.RTWInfo.CustomStorageClass = 'Const';
    
    temp.DataType = data_type;
    assignin('base', name, temp);
else
    evalin('base', [name ' = ' data_type '(' mat2str(value) ');']);
end

if length(name) > 31
    warning(['Name ' name ' exceeds maximum allowable length.'])
end
